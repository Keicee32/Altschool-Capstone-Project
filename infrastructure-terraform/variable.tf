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
variable "database_name" {}
variable "ami_type" {}
variable "instance_type" {}
variable "cluster_name" {}
variable "cluster_version" {}
variable "domain_name" {}
# variable "token" {}
# variable "username" {} 