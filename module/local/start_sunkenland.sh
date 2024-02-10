#!/bin/bash
set -e

echo "Syncing backup script"

aws s3 cp s3://${bucket}/backup_sunkenland.sh /home/${host_username}/sunkenland/backup_sunkenland.sh
chmod +x /home/${host_username}/sunkenland/backup_sunkenland.sh

echo "Setting crontab"

aws s3 cp s3://${bucket}/crontab /home/${host_username}/crontab
crontab < /home/${host_username}/crontab

echo "Preparing to start server"

export templdpath=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH
export SteamAppId=${steam_app_id}

echo "Checking if world files exist locally"

echo "TODO: Determine path(s) for world data"
# if [ ! -f "/home/${host_username}/.config/unity3d/IronGate/sunkenland/worlds_local/${world_name}.fwl" ]; then
#     echo "No world files found locally, checking if backups exist"
#     BACKUPS=$(aws s3api head-object --bucket ${bucket} --key "${world_name}.fwl" || true > /dev/null 2>&1)
#     if [ -z "$${BACKUPS}" ]; then
#         echo "No backups found using world name \"${world_name}\". A new world will be created."
#     else
#         echo "Backups found, restoring..."
#         aws s3 cp "s3://${bucket}/${world_name}.fwl" "/home/${host_username}/.config/unity3d/IronGate/sunkenland/worlds_local/${world_name}.fwl"
#         aws s3 cp "s3://${bucket}/${world_name}.db" "/home/${host_username}/.config/unity3d/IronGate/sunkenland/worlds_local/${world_name}.db"
#     fi
# else
#     echo "World files found locally"
# fi

echo "Starting server PRESS CTRL-C to exit"

echo "TODO: Confirm startup command"
# ./sunkenland_server.x86_64 -port 2456 -world "${world_name}" -password ${server_password} -batchmode -nographics -public 1

export LD_LIBRARY_PATH=$templdpath
