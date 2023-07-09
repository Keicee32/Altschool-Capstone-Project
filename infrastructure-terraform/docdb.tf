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

resource "aws_docdb_subnet_group" "capstone-24-docdb-subnet-group" {
  name       = "${var.project_name}-docdb-subnet-group"
  subnet_ids = [for AZ in aws_subnet.capstone-24-db-subnets : AZ.id]
  tags = {
    Name = "${var.project_name}-docdb-subnet-group"
  }
}
