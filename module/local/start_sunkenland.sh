#!/bin/bash
set -euo pipefail

echo "Syncing backup script"

aws s3 cp s3://${bucket}/backup_sunkenland.sh ${game_dir}/backup_sunkenland.sh
chmod +x ${game_dir}/backup_sunkenland.sh

echo "Setting crontab"

aws s3 cp s3://${bucket}/crontab ${game_dir}/crontab
crontab < ${game_dir}/crontab

%{ if auto_update_server }
echo "Checking for Sunkenland updates"
${install_update_cmd}
%{ endif }

echo "Reset Wine environment and initialize"
rm -rf /home/${host_username}/.wine
wineboot --init

SLEEP=15
echo "Wait for Wine initialization. Sleeping for $${SLEEP} seconds..."
sleep "$${SLEEP}"

echo "Starting xvfb"
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
  local_file="$${WORLD_DIR}/$${file}"
  s3_file="s3://${bucket}/$${file}"
  download_file "$${local_file}" "$${s3_file}"
done

echo "Creating server worlds directory"
mkdir -p /home/${host_username}/.wine/drive_c/users/${host_username}/AppData/LocalLow/Vector3\ Studio/Sunkenland
ln -sfn ${game_dir}/Worlds/ /home/${host_username}/.wine/drive_c/users/${host_username}/AppData/LocalLow/Vector3\ Studio/Sunkenland

echo "Starting server PRESS CTRL-C to exit"

# Start the Sunkenland server
wine ${game_dir}/Sunkenland-DedicatedServer.exe \
  -batchmode \
  -nographics \
  -logFile ${game_dir}/Worlds/sunkenland.log \
  -maxPlayerCapacity "${maxPlayerCapacity}" \
  -password "${password}" \
  -region "${region}" \
  -worldGuid "${worldGuid}" \
%{ if makeSessionInvisible }  -makeSessionInvisible \ %{ endif }
