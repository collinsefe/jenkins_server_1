# -------------
# Module Inputs
# -------------

provider "aws" {
  region = "eu-west-1"
}

variable "vpc_id" {
  default = "vpc-5194b536"
}

variable "customer_name" {
  default = "corighose"
}

variable "environment" {
  default = "dev"
}

variable "vpc_cidr" {
  default = "10.44.74.0/24"
}

variable "cidr_blocks" {
  default = "0.0.0.0/0"
}

variable "ssh_port" {
  default = "22"
}

variable "jenkins_web_port" {
  default = "80"
}

variable "jenkins_jnlp_port" {
  default = "50000"
}

variable "bastion_security_group" {
  default = "var.vpc_cidr"
}
