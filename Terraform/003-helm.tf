#----------------------------------------------------
#               Helm Chart Management
#----------------------------------------------------

resource "helm_release" "nginx-ingress-controller" {
  name       = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}

data "kubernetes_service" "EKS-ingress-service" {
  metadata {
    name = "nginx-ingress-controller"
  }
  depends_on = [
    helm_release.nginx-ingress-controller
  ]
}

resource "helm_release" "kube-prometheus-stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace  = "monitoring"
  chart      = "kube-prometheus-stack"
  timeout    = 600
}