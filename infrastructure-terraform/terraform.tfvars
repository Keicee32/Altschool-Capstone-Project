#----------------------------------------------------
#               Values of Variables
#----------------------------------------------------

project_name   = "capstone-24"
region         = "us-east-1"
vpc_cidr_block = "10.0.0.0/16"
public_subnet = {
  pub-1 = {
    sub_cidr_block = "10.0.1.0/24"
    AZ             = "us-east-1a"
  }
  pub-2 = {
    sub_cidr_block = "10.0.2.0/24"
    AZ             = "us-east-1b"
  }
}
private_subnet = {
  pri-1 = {
    sub_cidr_block = "10.0.3.0/24"
    AZ             = "us-east-1a"
  }
  pri-2 = {
    sub_cidr_block = "10.0.4.0/24"
    AZ             = "us-east-1b"
  }
}
database_subnet = {
  db-1 = {
    sub_cidr_block = "10.0.5.0/24"
    AZ             = "us-east-1a"
  }
  db-2 = {
    sub_cidr_block = "10.0.6.0/24"
    AZ             = "us-east-1b"
  }
}
destination_cidr_block = "0.0.0.0/0"
db_username            = "capstone-24"
db_password            = "keiceeolafavour"
ami_type               = "AL2_x86_64"
instance_type          = "t3.medium"
cluster_name           = "capstone-24-docdb-cluster"
domain_name            = "ibechuksvictor.live"