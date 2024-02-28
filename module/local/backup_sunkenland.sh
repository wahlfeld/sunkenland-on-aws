#!/bin/bash
set -euo pipefail

echo "Backing up Sunkenland world data"
WORLD_DIR="${game_dir}/Worlds/${world_folder_name}"

backup_file() {
  local local_file="$${1}"
  local s3_file="$${2}"
  if [ -f "$${local_file}" ]; then
    echo "Backing up $${local_file} to $${s3_file}"
    aws s3 cp "$${local_file}" "$${s3_file}" || echo "Error backing up $${local_file} to $${s3_file}"
  fi
}

world_files=(
  "StartGameConfig.json"
  "World.json"
  "WorldSetting.json"
)

for file in "$${world_files[@]}"; do
  local_file="$${WORLD_DIR/$${file}"
  s3_file="s3://${bucket}/backups/$${file}"
  backup_file "$${local_file}" "$${s3_file}"
done
