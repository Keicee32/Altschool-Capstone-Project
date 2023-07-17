#--------------------------------------------------------------
#                           Variables
#--------------------------------------------------------------

variable "region" {}
variable "project_name" {}
variable "vpc_cidr_block" {}
variable "ssh_cidr_block" {}
variable "public_subnet" {
  type = map(any)
}
variable "private_subnet" {
  type = map(any)
}
variable "database_subnet" {
  type = map(any)
}
variable "destination_cidr_block" {}
variable "db_username" {
  sensitive = true
  type      = string
}
variable "db_password" {
  sensitive = true
  type      = string
}
variable "ami_type" {}
variable "ec2_instance_type" {}
variable "db_instance_class" {}
variable "cluster_name" {}
variable "domain_name" {}
variable "token" {}
variable "username" {} 