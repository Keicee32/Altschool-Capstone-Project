#----------------------------------------------------
#                     EKS Cluster
#----------------------------------------------------

module "capstone-24-eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = true

  subnet_ids  = module.capstone-24-vpc.private_subnets
  vpc_id      = module.capstone-24-vpc.vpc_id
 
  eks_managed_node_groups = {
    dev = {
      desired_capacity = 4
      max_capacity     = 5
      min_capacity     = 3

      instance_types = [var.instance_type]
    }
  }
  tags = {
    environment = "development"
  }
}
