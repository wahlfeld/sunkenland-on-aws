#!/bin/bash
# TODO: Fix $LD_LIBRARY_PATH?
set -euo pipefail
# set -e

# TODO: Turn backups on
# echo "Syncing backup script"

# aws s3 cp s3://${bucket}/backup_sunkenland.sh ${game_dir}/backup_sunkenland.sh
# chmod +x ${game_dir}/backup_sunkenland.sh

# echo "Setting crontab"

# aws s3 cp s3://${bucket}/crontab /home/${host_username}/crontab
# crontab < /home/${host_username}/crontab

echo "Preparing to start server"

# TODO: Unsure if we need this
# export templdpath=$LD_LIBRARY_PATH
# export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
# export SteamAppId=${steam_app_id}

# echo "Checking if world files exist locally"
# TODO
mkdir -p "${game_dir}/Worlds/${world_guid}"
echo "Fetching template world files from S3"
if [ ! -f "${game_dir}/Worlds/${world_guid}/StartGameConfig.json" ]; then aws s3 cp "s3://${bucket}/StartGameConfig.json" "${game_dir}/Worlds/${world_guid}/StartGameConfig.json"; fi
if [ ! -f "${game_dir}/Worlds/${world_guid}/World.json" ]; then aws s3 cp "s3://${bucket}/StartGameConfig.json" "${game_dir}/Worlds/${world_guid}/World.json"; fi
if [ ! -f "${game_dir}/Worlds/${world_guid}/WorldSetting.json" ]; then aws s3 cp "s3://${bucket}/StartGameConfig.json" "${game_dir}/Worlds/${world_guid}/WorldSetting.json"; fi
# if [ ! -f "${game_dir}/Worlds/${world_guid}.fwl" ]; then
#     echo "No world file found locally, checking if backups exist"
#     BACKUPS=$(aws s3api head-object --bucket ${bucket} --key "${world_guid}.fwl" || true > /dev/null 2>&1)
#     if [ -z "$${BACKUPS}" ]; then
#         echo "No backups found using world name \"${world_guid}\". A new world will be created."
#     else
#         echo "Backups found, restoring..."
#         aws s3 cp "s3://${bucket}/${world_guid}.fwl" "${game_dir}/Worlds/${world_guid}.fwl"
#     fi
# else
#     echo "World files found locally"
# fi

echo "Clean up Wine environment and initialize"
# rm -rf /home/${host_username}/.wine
wineboot --init

SLEEP=30
echo "Wait for Wine initialization. Sleeping for $${SLEEP} seconds..."
sleep "$${SLEEP}"

echo "Set up world directory"
mkdir -p /home/${host_username}/.wine/drive_c/users/${host_username}/AppData/LocalLow/Vector3\ Studio/Sunkenland
ln -sfn ${game_dir}/Worlds/ /home/${host_username}/.wine/drive_c/users/${host_username}/AppData/LocalLow/Vector3\ Studio/Sunkenland

# TODO: Unsure if we need xvfb
Xvfb :1 &
export DISPLAY=:1

echo "Starting server PRESS CTRL-C to exit"

# TODO: Parameterise server start arguments
# TODO: Update server version to 0.2.03
# Start the Sunkenland server
wine ${game_dir}/Sunkenland-DedicatedServer.exe \
    -nographics \
    -batchmode \
    -logFile ${game_dir}/Worlds/sunkenland.log \
    -worldGuid ${world_guid} \
    -region "${server_region}" \
    -port 27015 \
    -queryport 27015 \
    -maxPlayerCapacity 10

# export LD_LIBRARY_PATH=$templdpath
