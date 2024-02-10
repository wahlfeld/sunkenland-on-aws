locals {
  host_username  = "slserver"
  name           = var.purpose != "prod" ? "sunkenland-${var.purpose}${var.unique_id}" : "sunkenland"
  steam_app_id   = "2667530"
  steam_password = sensitive(data.aws_secretsmanager_secret_version.steam_password.secret_string)
  tags = {
    "Purpose"   = var.purpose
    "Component" = "Sunkenland Server"
    "CreatedBy" = "Terraform"
  }
  ec2_tags = merge(local.tags,
    {
      "Name"        = "${local.name}-server"
      "Description" = "Instance running a Sunkenland server"
    }
  )
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

variable "steam_password_secret_path" {
  type = string
}

variable "steam_username" {
  type = string
}

variable "unique_id" {
  type = string
}

variable "world_name" {
  type = string
}
