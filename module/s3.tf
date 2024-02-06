#tfsec:ignore:AWS002
resource "aws_s3_bucket" "sunkenland" {
  #checkov:skip=CKV_AWS_18:Access logging is an extra cost and unecessary for this implementation
  #checkov:skip=CKV_AWS_144:Cross-region replication is an extra cost and unecessary for this implementation
  #checkov:skip=CKV_AWS_52:MFA delete is unecessary for this implementation
  #checkov:skip=CKV2_AWS_62:Event notifications are unecessary for this implementation
  bucket_prefix = local.name
  tags          = local.tags
}

resource "aws_s3_bucket_versioning" "sunkenland" {
  bucket = aws_s3_bucket.sunkenland.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "sunkenland" {
  #checkov:skip=CKV2_AWS_65: https://github.com/bridgecrewio/checkov/issues/5623
  bucket = aws_s3_bucket.sunkenland.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "sunkenland" {
  #checkov:skip=CKV_AWS_300:Unnecessary to setup a period for aborting failed uploads
  bucket = aws_s3_bucket.sunkenland.id

  rule {
    id     = "rule-1"
    status = "Enabled"

    expiration {
      days = var.s3_lifecycle_expiration
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sunkenland" {
  bucket = aws_s3_bucket.sunkenland.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_policy" "sunkenland" {
  bucket = aws_s3_bucket.sunkenland.id
  policy = jsonencode({
    Version : "2012-10-17",
    Id : "PolicyForsunkenlandBackups",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          "AWS" : aws_iam_role.sunkenland.arn
        },
        Action : [
          "s3:Put*",
          "s3:Get*",
          "s3:List*"
        ],
        Resource : "arn:aws:s3:::${aws_s3_bucket.sunkenland.id}/*"
      }
    ]
  })

  // https://github.com/hashicorp/terraform-provider-aws/issues/7628
  depends_on = [aws_s3_bucket_public_access_block.sunkenland]
}

resource "aws_s3_bucket_public_access_block" "sunkenland" {
  bucket = aws_s3_bucket.sunkenland.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "install_sunkenland" {
  #checkov:skip=CKV_AWS_186:KMS encryption is not necessary
  bucket         = aws_s3_bucket.sunkenland.id
  key            = "/install_sunkenland.sh"
  content_base64 = base64encode(templatefile("${path.module}/local/install_sunkenland.sh", { username = local.username }))
  etag           = filemd5("${path.module}/local/install_sunkenland.sh")
}

resource "aws_s3_object" "bootstrap_sunkenland" {
  #checkov:skip=CKV_AWS_186:KMS encryption is not necessary
  bucket = aws_s3_bucket.sunkenland.id
  key    = "/bootstrap_sunkenland.sh"
  content_base64 = base64encode(templatefile("${path.module}/local/bootstrap_sunkenland.sh", {
    username = local.username
    bucket   = aws_s3_bucket.sunkenland.id
  }))
  etag = filemd5("${path.module}/local/bootstrap_sunkenland.sh")
}

resource "aws_s3_object" "start_sunkenland" {
  #checkov:skip=CKV_AWS_186:KMS encryption is not necessary
  bucket = aws_s3_bucket.sunkenland.id
  key    = "/start_sunkenland.sh"
  content_base64 = base64encode(templatefile("${path.module}/local/start_sunkenland.sh", {
    username        = local.username
    bucket          = aws_s3_bucket.sunkenland.id
    world_name      = var.world_name
    server_password = var.server_password
  }))
  etag = filemd5("${path.module}/local/start_sunkenland.sh")
}

resource "aws_s3_object" "backup_sunkenland" {
  #checkov:skip=CKV_AWS_186:KMS encryption is not necessary
  bucket = aws_s3_bucket.sunkenland.id
  key    = "/backup_sunkenland.sh"
  content_base64 = base64encode(templatefile("${path.module}/local/backup_sunkenland.sh", {
    username   = local.username
    bucket     = aws_s3_bucket.sunkenland.id
    world_name = var.world_name
  }))
  etag = filemd5("${path.module}/local/backup_sunkenland.sh")
}

resource "aws_s3_object" "crontab" {
  #checkov:skip=CKV_AWS_186:KMS encryption is not necessary
  bucket         = aws_s3_bucket.sunkenland.id
  key            = "/crontab"
  content_base64 = base64encode(templatefile("${path.module}/local/crontab", { username = local.username }))
  etag           = filemd5("${path.module}/local/crontab")
}

resource "aws_s3_object" "sunkenland_service" {
  #checkov:skip=CKV_AWS_186:KMS encryption is not necessary
  bucket = aws_s3_bucket.sunkenland.id
  key    = "/sunkenland.service"
  content_base64 = base64encode(templatefile("${path.module}/local/sunkenland.service", {
    username = local.username
  }))
  etag = filemd5("${path.module}/local/sunkenland.service")
}

output "bucket_id" {
  value = aws_s3_bucket.sunkenland.id
}
