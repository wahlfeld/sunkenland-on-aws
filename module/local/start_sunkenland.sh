#!/bin/bash
set -euo pipefail

# TODO: Is this important?
# Sunkenland game (app) ID: https://steamdb.info/app/2080690/info/
export SteamAppId=2080690

echo "Reset Wine environment and initialize"
rm -rf /home/${host_username}/.wine
wineboot --init

SLEEP=15
echo "Wait for Wine initialization. Sleeping for $${SLEEP} seconds..."
sleep "$${SLEEP}"

# TODO: Test is xvfb is required
echo "Starting xvfb (may not be required)"
Xvfb :1 &
export DISPLAY=:1

echo "Preparing world data"
WORLD_DIR="${game_dir}/Worlds/${world_folder_name}"
mkdir -p "$${WORLD_DIR}"

download_file() {
  local local_file="$${1}"
  local s3_file="$${2}"
  if [ ! -f "$${local_file}" ]; then
    echo "Downloading $${s3_file} to $${local_file}"
    aws s3 cp "$${s3_file}" "$${local_file}" || echo "Error downloading $${s3_file} to $${local_file}"
  fi
}

world_files=(
  "StartGameConfig.json"
  "World.json"
  "WorldSetting.json"
)

for file in "$${world_files[@]}"; do
  local_file="$${WORLD_DIR/$${file}"
  s3_file="s3://${bucket}/$${file}"
  download_file "$${local_file}" "$${s3_file}"
done

echo "Creating server worlds directory"
mkdir -p /home/${host_username}/.wine/drive_c/users/${host_username}/AppData/LocalLow/Vector3\ Studio/Sunkenland
ln -sfn ${game_dir}/Worlds/ /home/${host_username}/.wine/drive_c/users/${host_username}/AppData/LocalLow/Vector3\ Studio/Sunkenland

echo "Starting server PRESS CTRL-C to exit"

# Start the Sunkenland server
wine ${game_dir}/Sunkenland-DedicatedServer.exe \
    -nographics \
    -batchmode \
    -logFile ${game_dir}/Worlds/sunkenland.log \
    -worldGuid "${world_guid}" \
    -region "${server_region}"
