#!/bin/bash
# TODO: Fix $LD_LIBRARY_PATH?
set -euo pipefail
# set -e

# TODO: Turn backups on
# echo "Syncing backup script"

# aws s3 cp s3://${bucket}/backup_sunkenland.sh /home/${host_username}/sunkenland/backup_sunkenland.sh
# chmod +x /home/${host_username}/sunkenland/backup_sunkenland.sh

# echo "Setting crontab"

# aws s3 cp s3://${bucket}/crontab /home/${host_username}/crontab
# crontab < /home/${host_username}/crontab

echo "Preparing to start server"

# TODO: Unsure if we need this
# export templdpath=$LD_LIBRARY_PATH
# export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
# export SteamAppId=${steam_app_id}

echo "Checking if world files exist locally"

echo "TODO: Determine path(s) for world data"
# if [ ! -f "/home/${host_username}/sunkenland/worlds/${world_guid}.fwl" ]; then
#     echo "No world file found locally, checking if backups exist"
#     BACKUPS=$(aws s3api head-object --bucket ${bucket} --key "${world_guid}.fwl" || true > /dev/null 2>&1)
#     if [ -z "$${BACKUPS}" ]; then
#         echo "No backups found using world name \"${world_guid}\". A new world will be created."
#     else
#         echo "Backups found, restoring..."
#         aws s3 cp "s3://${bucket}/${world_guid}.fwl" "/home/${host_username}/sunkenland/worlds/${world_guid}.fwl"
#         aws s3 cp "s3://${bucket}/${world_guid}.db" "/home/${host_username}/sunkenland/worlds/${world_guid}.db"
#     fi
# else
#     echo "World files found locally"
# fi

echo "Clean up Wine environment and initialize"
rm -rf /home/${host_username}/.wine
wineboot --init

echo "Wait for Wine initialization"
until [[ -f /home/${host_username}/.wine/system.reg ]]; do
    sleep 1
done

echo "Set up world directory"
mkdir -p /home/${host_username}/.wine/drive_c/users/root/AppData/LocalLow/Vector3\ Studio/Sunkenland/Worlds
ln -s /home/${host_username}/sunkenland/worlds /home/${host_username}/.wine/drive_c/users/root/AppData/LocalLow/Vector3\ Studio/Sunkenland/Worlds

# TODO: Unsure if we need xvfb
Xvfb :1 &
export DISPLAY=:1

echo "Starting server PRESS CTRL-C to exit"

# Start the Sunkenland server
wine /home/${host_username}/sunkenland/Sunkenland-DedicatedServer.exe \
    -nographics -batchmode \
    -logFile /home/${host_username}/sunkenland/worlds/sunkenland.log \
    -maxPlayerCapacity 10 \
    -password ${server_password} \
    -worldGuid "${world_guid}" \
    -region "${server_region}"

# export LD_LIBRARY_PATH=$templdpath
