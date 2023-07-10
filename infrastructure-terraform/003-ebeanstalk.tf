#----------------------------------------------------
#                     Elastic Beanstalk
#----------------------------------------------------

resource "aws_elastic_beanstalk_application" "capstone-24-app" {
  name        = var.project_name
  description = "${var.project_name} application"

}

resource "aws_elastic_beanstalk_environment" "capstone-24-app-env" {
  name                = "${var.project_name}-env"
  application         = aws_elastic_beanstalk_application.capstone-24-app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.5.9 running Docker"
  tier                = "WebServer"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.capstone-24-vpc.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(", ", [for subnets in aws_subnet.capstone-24-pub-subnets : subnets.id])
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(", ", [for subnets in aws_subnet.capstone-24-pri-subnets : subnets.id])
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "DBSubnets"
    value     = join(", ", [for subnets in aws_subnet.capstone-24-db-subnets : subnets.id])
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "internet facing"
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceType"
    value     = var.ec2_instance_type
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "SecurityGroups"
    value     = ""
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "EnableSpot"
    value     = "true"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Custom Availability Zones"
    value     = join(", ", [for AZ in aws_subnet.capstone-24-pri-subnets : AZ.availability_zone])
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "EnableCapacityRebalance"
    value     = "true"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "5"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "3"
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
    value     = "true"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.capstone-24-ec2-sg.id
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "SecurityGroups"
    value     = aws_security_group.capstone-24-lb-sg.id
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "Protocol"
    value     = "HTTPS"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLCertificateArns"
    value     = aws_acm_certificate.capstone-24-ssl-cert.arn
  }
}
