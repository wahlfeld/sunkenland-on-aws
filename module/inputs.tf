locals {
  host_username     = "slserver"
  game_dir          = "/home/${local.host_username}/sunkenland"
  name              = var.purpose != "prod" ? "sunkenland-${var.purpose}${var.unique_id}" : "sunkenland"
  steam_app_id      = "2667530"
  world_folder_name = "${var.world_name}~${var.world_guid}"

  install_update_cmd = <<EOT
/home/${local.host_username}/Steam/steamcmd.sh \
    +force_install_dir ${local.game_dir} \
    +login anonymous \
    +@sSteamCmdForcePlatformType windows \
    +app_update ${local.steam_app_id} \
    validate \
    +quit
EOT

  start_server_cmd = "wine ${local.game_dir}/Sunkenland-DedicatedServer.exe"
  args = [
    "-batchmode",
    "-nographics",
    "-logFile ${local.game_dir}/Worlds/sunkenland.log",
    "-maxPlayerCapacity ${var.max_players}",
    "-password ${var.server_password}",
    "-region ${var.server_region}",
    "-worldGuid ${var.world_guid}",
  ]

  start_server_cmd_with_args = "${local.start_server_cmd} ${join(" ", local.args)}"

  optional_args = concat(
    var.session_visible ? [] : ["-makeSessionInvisible"],
    var.server_local_port != null ? ["-port ${var.server_local_port}"] : [],
    var.server_public_port != null ? ["-publicPort ${var.server_public_port}"] : [],
    var.server_local_address != null ? ["-ip ${var.server_local_address}"] : [],
    var.server_public_address != null ? ["-publicIP ${var.server_public_address}"] : [],
  )

  start_server_cmd_with_optional_args = "${local.start_server_cmd_with_args} ${join(" ", local.optional_args)}"

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

variable "auto_update_server" {
  type = bool
}

variable "aws_region" {
  type = string
}

variable "death_penalties" {
  type = bool
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
  validation {
    condition     = var.max_players >= 3 && var.max_players <= 15
    error_message = "'max_players' must be between 3 and 15 (inclusive)."
  }
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

variable "server_local_address" {
  type = string
}

variable "server_local_port" {
  type = number
}

variable "server_password" {
  type = string
  validation {
    condition     = length(var.server_password) <= 8
    error_message = "The 'server_password' must be a maximum of 8 characters long."
  }
}

variable "server_public_address" {
  type = string
}

variable "server_public_port" {
  type = number
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

variable "world_guid" {
  type = string
}

variable "world_name" {
  type = string
}
