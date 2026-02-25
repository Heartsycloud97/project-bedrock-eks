variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "student_id" {
  type    = string
  default = "alt-soe-025-0259"
}

variable "cluster_name" {
  type    = string
  default = "project-bedrock-cluster"
}

variable "vpc_name" {
  type    = string
  default = "project-bedrock-vpc"
}

variable "app_namespace" {
  type    = string
  default = "retail-app"
}

variable "dev_user_name" {
  type    = string
  default = "bedrock-dev-view"
}