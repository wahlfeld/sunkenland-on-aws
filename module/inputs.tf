locals {
  username = "vhserver"
  tags = {
    "Purpose"   = var.purpose
    "Component" = "sunkenland Server"
    "CreatedBy" = "Terraform"
  }
  ec2_tags = merge(local.tags,
    {
      "Name"        = "${local.name}-server"
      "Description" = "Instance running a Sunkenland server"
    }
  )
  name       = var.purpose != "prod" ? "sunkenland-${var.purpose}${var.unique_id}" : "sunkenland"
}

variable "aws_region" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "purpose" {
  type = string
}

variable "s3_lifecycle_expiration" {
  type = string
}

variable "server_password" {
  type = string
}

variable "sns_email" {
  type = string
}

variable "unique_id" {
  type = string
}

variable "world_name" {
  type = string
}
