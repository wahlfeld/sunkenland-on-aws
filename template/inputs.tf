variable "aws_region" {
  type        = string
  description = "The AWS region to create the Sunkenland server"
}

variable "instance_type" {
  type        = string
  default     = "t3a.medium"
  description = "AWS EC2 instance type to run the server on (t3a.medium is the minimum size)"
}

variable "purpose" {
  type        = string
  default     = "prod"
  description = "The purpose of the deployment"
}

variable "s3_lifecycle_expiration" {
  type        = string
  default     = "90"
  description = "The number of days to keep files (backups) in the S3 bucket before deletion"
}

variable "server_password" {
  type        = string
  description = "The server password"
}

variable "sns_email" {
  type        = string
  description = "The email address to send alerts to"
}

variable "steam_password_secret_path" {
  type        = string
  description = "The AWS Secrets Manager path to the Steam username password"
}

variable "steam_username" {
  type        = string
  description = "The Steam username used to auth and download Sunkenland from Steam"
}

variable "unique_id" {
  type        = string
  default     = ""
  description = "The ID of the deployment (used for tests)"
}

variable "world_name" {
  type        = string
  description = "The Sunkenland world name"
}
