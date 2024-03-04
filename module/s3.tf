#tfsec:ignore:AWS002
resource "aws_s3_bucket" "sunkenland" {
  #checkov:skip=CKV_AWS_18:Access logging is an extra cost and unecessary for this implementation
  #checkov:skip=CKV_AWS_144:Cross-region replication is an extra cost and unecessary for this implementation
  #checkov:skip=CKV_AWS_52:MFA delete is unecessary for this implementation
  #checkov:skip=CKV2_AWS_62:Event notifications are unecessary for this implementation
  bucket_prefix = local.name
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
  bucket = aws_s3_bucket.sunkenland.id
  key    = "/install_sunkenland.sh"
  content_base64 = base64encode(templatefile("${path.module}/local/install_sunkenland.sh", {
    game_dir           = local.game_dir
    host_username      = local.host_username
    install_update_cmd = local.install_update_cmd
    steam_app_id       = local.steam_app_id
  }))
  etag = filemd5("${path.module}/local/install_sunkenland.sh")
}

resource "aws_s3_object" "bootstrap_sunkenland" {
  #checkov:skip=CKV_AWS_186:KMS encryption is not necessary
  bucket = aws_s3_bucket.sunkenland.id
  key    = "/bootstrap_sunkenland.sh"
  content_base64 = base64encode(templatefile("${path.module}/local/bootstrap_sunkenland.sh", {
    bucket        = aws_s3_bucket.sunkenland.id
    game_dir      = local.game_dir
    host_username = local.host_username
  }))
  etag = filemd5("${path.module}/local/bootstrap_sunkenland.sh")
}

resource "aws_s3_object" "start_sunkenland" {
  #checkov:skip=CKV_AWS_186:KMS encryption is not necessary
  bucket = aws_s3_bucket.sunkenland.id
  key    = "/start_sunkenland.sh"
  content_base64 = base64encode(templatefile("${path.module}/local/start_sunkenland.sh", {
    auto_update_server   = var.auto_update_server
    bucket               = aws_s3_bucket.sunkenland.id
    game_dir             = local.game_dir
    host_username        = local.host_username
    install_update_cmd   = local.install_update_cmd
    password             = var.server_password
    region               = var.server_region
    makeSessionInvisible = !var.session_visible
    maxPlayerCapacity    = var.max_players
    steam_app_id         = local.steam_app_id
    world_folder_name    = local.world_folder_name
    worldGuid            = local.world_guid
  }))
  etag = filemd5("${path.module}/local/start_sunkenland.sh")
}

resource "aws_s3_object" "backup_sunkenland" {
  #checkov:skip=CKV_AWS_186:KMS encryption is not necessary
  bucket = aws_s3_bucket.sunkenland.id
  key    = "/backup_sunkenland.sh"
  content_base64 = base64encode(templatefile("${path.module}/local/backup_sunkenland.sh", {
    bucket            = aws_s3_bucket.sunkenland.id
    game_dir          = local.game_dir
    host_username     = local.host_username
    world_folder_name = local.world_folder_name
    world_guid        = local.world_guid
  }))
  etag = filemd5("${path.module}/local/backup_sunkenland.sh")
}

resource "aws_s3_object" "crontab" {
  #checkov:skip=CKV_AWS_186:KMS encryption is not necessary
  bucket = aws_s3_bucket.sunkenland.id
  key    = "/crontab"
  content_base64 = base64encode(templatefile("${path.module}/local/crontab", {
    game_dir      = local.game_dir
    host_username = local.host_username
  }))
  etag = filemd5("${path.module}/local/crontab")
}

resource "aws_s3_object" "sunkenland_service" {
  #checkov:skip=CKV_AWS_186:KMS encryption is not necessary
  bucket = aws_s3_bucket.sunkenland.id
  key    = "/sunkenland.service"
  content_base64 = base64encode(templatefile("${path.module}/local/sunkenland.service", {
    game_dir      = local.game_dir
    host_username = local.host_username
    steam_app_id  = local.steam_app_id
  }))
  etag = filemd5("${path.module}/local/sunkenland.service")
}

# TODO: Parameterise contents of these world files
resource "aws_s3_object" "sunkenland_world" {
  #checkov:skip=CKV_AWS_186:KMS encryption is not necessary
  bucket         = aws_s3_bucket.sunkenland.id
  key            = "/World.json"
  content_base64 = base64encode(file("${path.module}/local/World.json"))
  etag           = filemd5("${path.module}/local/World.json")
}

# TODO: Parameterise contents of these world files
resource "aws_s3_object" "sunkenland_world_config" {
  #checkov:skip=CKV_AWS_186:KMS encryption is not necessary
  bucket = aws_s3_bucket.sunkenland.id
  key    = "/StartGameConfig.json"
  content_base64 = base64encode(templatefile("${path.module}/local/StartGameConfig.json", {
    isSessionVisible  = var.session_visible
    serverPassword    = var.server_password
    maxPlayerCapacity = var.max_players
  }))
  etag = filemd5("${path.module}/local/StartGameConfig.json")
}

# TODO: Parameterise contents of these world files
resource "aws_s3_object" "sunkenland_world_setting" {
  #checkov:skip=CKV_AWS_186:KMS encryption is not necessary
  bucket = aws_s3_bucket.sunkenland.id
  key    = "/WorldSetting.json"
  content_base64 = base64encode(templatefile("${path.module}/local/WorldSetting.json", {
    worldDescription          = var.world_description
    enemyDifficulty           = var.enemy_difficulty
    enemyGarrisonDifficulty   = var.enemy_garrison_difficulty
    enemyRaidDifficulty       = var.enemy_raid_difficulty
    survivalDifficulty        = var.survival_difficulty
    isDeathPenaltiesEnabled   = var.death_penalties
    isFriendlyFireEnabled     = var.friendly_fire
    isResearchShared          = var.research_shared
    isMapShared               = var.map_shared
    isFlagShared              = var.flag_shared
    isSpawnPointShared        = var.spawn_point_shared
    isUsingRandomSpawnPoints  = var.random_spawn_points
    respawnTime               = var.respawn_time
    lootRespawnIntervalInDays = var.loot_respawn_time_in_days
  }))
  etag = filemd5("${path.module}/local/WorldSetting.json")
}
