variable "application_version" {
  type    = string
  default = "0.2.03"
}

variable "aws_region" {
  type        = string
  description = "The AWS region to create the Sunkenland server"
}

variable "enemy_difficulty" {
  type    = number
  default = 1
}

variable "enemy_garrison_difficulty" {
  type    = number
  default = 2
}

variable "enemy_raid_difficulty" {
  type    = number
  default = 2
}

variable "flag_shared" {
  type    = bool
  default = true
}

variable "friendly_fire" {
  type    = bool
  default = false
}

variable "instance_type" {
  type        = string
  default     = "t3a.large"
  description = "AWS EC2 instance type to run the server on (2 vCPUs / 8 GiB minimum)"
}

variable "loot_respawn_time_in_days" {
  type    = number
  default = 4
}

variable "map_shared" {
  type    = bool
  default = true
}

variable "max_players" {
  type    = number
  default = 10
}

variable "purpose" {
  type        = string
  default     = "prod"
  description = "The purpose of the deployment"
}

variable "random_spawn_points" {
  type    = bool
  default = false
}

variable "research_shared" {
  type    = bool
  default = true
}

variable "respawn_time" {
  type    = number
  default = 10
}

variable "s3_lifecycle_expiration" {
  type        = string
  default     = "90"
  description = "The number of days to keep files (backups) in the S3 bucket before deletion"
}

variable "server_password" {
  type        = string
  default     = ""
  description = "The server password"
}

variable "server_region" {
  type        = string
  default     = "asia"
  description = "The region to host the Sunkenland server"
}

variable "session_visible" {
  type    = bool
  default = true
}

variable "sns_email" {
  type        = string
  description = "The email address to send alerts to"
}

variable "spawn_point_shared" {
  type    = bool
  default = true
}

variable "survival_difficulty" {
  type    = number
  default = 1
}

variable "unique_id" {
  type        = string
  default     = ""
  description = "The ID of the deployment (used for tests)"
}

variable "world_description" {
  type    = string
  default = ""
}

variable "world_name" {
  type        = string
  description = "Name of the server shown in the Sunkenland server browser"
  default     = "template"
}
