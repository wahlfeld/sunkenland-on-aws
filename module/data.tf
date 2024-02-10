data "aws_secretsmanager_secret_version" "steam_password" {
  secret_id = var.steam_password_secret_path
}
