#----------------------------------------------------
#              Document DB Cluster
#----------------------------------------------------
resource "aws_docdb_subnet_group" "capstone-24-docdb-subnet-group" {
  name       = "${var.project_name}-docdb-subnet-group"
  subnet_ids = [for AZ in aws_subnet.capstone-24-db-subnets : AZ.id]
  tags = {
    Name = "${var.project_name}-docdb-subnet-group"
  }
}

resource "aws_docdb_cluster_instance" "capstone-24-docdb-cluster-instance" {
  count              = 2
  identifier         = "${var.cluster_name}-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.capstone-24-docdb-cluster.id
  instance_class     = var.db_instance_class
  tags = {
    Name = "${var.project_name}-docdb-cluster-instance"
  }
}

resource "aws_docdb_cluster" "capstone-24-docdb-cluster" {
  cluster_identifier        = var.cluster_name
  engine                    = "docdb"
  master_username           = var.db_username
  master_password           = var.db_password
  backup_retention_period   = 5
  final_snapshot_identifier = "capstone-24-docdb-cluster-final-snapshot"
  vpc_security_group_ids    = [aws_security_group.capstone-24-docdb-sg.id]
  db_subnet_group_name      = aws_docdb_subnet_group.capstone-24-docdb-subnet-group.id
  tags = {
    Name = "${var.project_name}-docdb-cluster"
  }
}

resource "aws_docdb_cluster_parameter_group" "capstone-24-docdb-cluster-parameter-group" {
  name        = "${var.project_name}-docdb-cluster-parameter-group"
  family      = "docdb3.6"
  description = "Parameter group for ${var.project_name} docdb cluster"

  parameter {
    name  = "tls"
    value = "disabled"
  }
  
  tags = {
    Name = "${var.project_name}-docdb-cluster-parameter-group"
  }
}