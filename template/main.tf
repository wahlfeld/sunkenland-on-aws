module "main" {
  source = "../module"

  aws_region                 = var.aws_region
  instance_type              = var.instance_type
  purpose                    = var.purpose
  s3_lifecycle_expiration    = var.s3_lifecycle_expiration
  server_password            = var.server_password
  sns_email                  = var.sns_email
  steam_password_secret_path = var.steam_password_secret_path
  steam_username             = var.steam_username
  unique_id                  = var.unique_id
  world_name                 = var.world_name
}
