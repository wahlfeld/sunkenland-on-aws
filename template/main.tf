module "main" {
  source = "../module"

  aws_region              = var.aws_region
  instance_type           = var.instance_type
  purpose                 = var.purpose
  s3_lifecycle_expiration = var.s3_lifecycle_expiration
  server_password         = var.server_password
  server_region           = var.server_region
  sns_email               = var.sns_email
  unique_id               = var.unique_id
  world_guid              = var.world_guid
}
