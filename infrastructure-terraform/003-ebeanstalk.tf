#----------------------------------------------------
#                     Elastic Beanstalk
#----------------------------------------------------

resource "aws_elastic_beanstalk_application" "capstone-24-app" {
  name        = "${var.project_name}-app"
  description = "${var.project_name} application"

}

resource "aws_elastic_beanstalk_environment" "capstone-24-app-env" {
  name                   = "${var.project_name}-env"
  application            = aws_elastic_beanstalk_application.capstone-24-app.name
  wait_for_ready_timeout = "30m"
  solution_stack_name    = "64bit Amazon Linux 2 v3.5.9 running Docker"
  tier                   = "WebServer"

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

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_HOST"
    value     = aws_docdb_cluster.capstone-24-docdb-cluster.endpoint
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_PORT"
    value     = "27017"
  }

  # setting {
  #   namespace = "aws:elasticbeanstalk:application:environment"
  #   name      = "DB_USERNAME"
  #   value     = var.db_username
  # }

  # setting {
  #   namespace = "aws:elasticbeanstalk:application:environment"
  #   name      = "DB_PASSWORD"
  #   value     = var.db_password
  # }
}

resource "aws_s3_bucket" "capstone-24-app" {
  bucket = "${var.project_name}-app"
}

resource "aws_s3_object" "capstone-24-app" {
  bucket = aws_s3_bucket.capstone-24-app.id
  key    = "docker/capstone-24-app.zip"
  source = "Altschool-Capstone-Project/capstone-24-app.zip"
  # etag   = filemd5("Altschool-Capstone-Project/capstone-24-app.zip")
}

resource "aws_elastic_beanstalk_application_version" "capstone-24-app-version" {
  name        = "capstone-24-app-v1"
  application = aws_elastic_beanstalk_application.capstone-24-app.name
  description = "Application Version 1"
  bucket      = aws_s3_bucket.capstone-24-app.id
  key         = aws_s3_object.capstone-24-app.id
}
