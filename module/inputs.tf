locals {
  host_username     = "slserver"
  game_dir          = "/home/${local.host_username}/sunkenland"
  name              = var.purpose != "prod" ? "sunkenland-${var.purpose}${var.unique_id}" : "sunkenland"
  steam_app_id      = "2667530"
  world_name        = "template"                             # TODO: Validate if this name matters
  world_guid        = "8126a58f-b357-4606-8ae1-b6d4f57e8b32" # TODO: Validate if this name matters
  world_folder_name = "${local.world_name}~${local.world_guid}"

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

variable "application_version" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "enemy_difficulty" {
  type = number
}

variable "enemy_garrison_difficulty" {
  type = number
}

variable "enemy_raid_difficulty" {
  type = number
}

variable "flag_shared" {
  type = bool
}

variable "friendly_fire" {
  type = bool
}

variable "instance_type" {
  type = string
}

variable "loot_respawn_time_in_days" {
  type = number
}

variable "map_shared" {
  type = bool
}

variable "max_players" {
  type = number
}

variable "purpose" {
  type = string
}

variable "random_spawn_points" {
  type = bool
}

variable "research_shared" {
  type = bool
}

variable "respawn_time" {
  type = number
}

variable "s3_lifecycle_expiration" {
  type = string
}

variable "server_password" {
  type = string
}

variable "server_region" {
  type = string
}

variable "session_visible" {
  type = bool
}

variable "sns_email" {
  type = string
}

variable "spawn_point_shared" {
  type = bool
}

variable "survival_difficulty" {
  type = number
}

variable "unique_id" {
  type = string
}

variable "world_description" {
  type = string
}
