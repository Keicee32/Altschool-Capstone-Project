#--------------------------------------------------------------
#                           Variables
#--------------------------------------------------------------

variable "region" {}
variable "project_name" {}
variable "vpc_cidr_block" {}
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
variable "db_username" {}
variable "db_password" {}
variable "ami_type" {}
variable "instance_type" {}
variable "cluster_name" {}
variable "domain_name" {}
variable "token" {}
variable "username" {} 