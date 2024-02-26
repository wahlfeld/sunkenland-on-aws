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
mkdir -p "${game_dir}/Worlds/${world_folder_name}"

echo "Fetching world files from S3 if not present locally"
if [ ! -f "${game_dir}/Worlds/${world_folder_name}/StartGameConfig.json" ]; then aws s3 cp "s3://${bucket}/StartGameConfig.json" "${game_dir}/Worlds/${world_folder_name}/StartGameConfig.json"; fi
if [ ! -f "${game_dir}/Worlds/${world_folder_name}/World.json" ]; then aws s3 cp "s3://${bucket}/World.json" "${game_dir}/Worlds/${world_folder_name}/World.json"; fi
if [ ! -f "${game_dir}/Worlds/${world_folder_name}/WorldSetting.json" ]; then aws s3 cp "s3://${bucket}/WorldSetting.json" "${game_dir}/Worlds/${world_folder_name}/WorldSetting.json"; fi

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
