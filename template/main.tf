module "main" {
  source = "../module"

  application_version       = var.application_version
  aws_region                = var.aws_region
  enemy_difficulty          = var.enemy_difficulty
  enemy_garrison_difficulty = var.enemy_garrison_difficulty
  enemy_raid_difficulty     = var.enemy_raid_difficulty
  flag_shared               = var.flag_shared
  friendly_fire             = var.friendly_fire
  instance_type             = var.instance_type
  loot_respawn_time_in_days = var.loot_respawn_time_in_days
  map_shared                = var.map_shared
  max_players               = var.max_players
  purpose                   = var.purpose
  random_spawn_points       = var.random_spawn_points
  research_shared           = var.research_shared
  respawn_time              = var.respawn_time
  s3_lifecycle_expiration   = var.s3_lifecycle_expiration
  server_password           = var.server_password
  server_region             = var.server_region
  session_visible           = var.session_visible
  sns_email                 = var.sns_email
  spawn_point_shared        = var.spawn_point_shared
  survival_difficulty       = var.survival_difficulty
  unique_id                 = var.unique_id
  world_description         = var.world_description
}
