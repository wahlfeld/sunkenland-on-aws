#!/bin/bash
set -euo pipefail

echo "Installing Sunkenland server"

mkdir -p /home/${host_username}/Steam && cd /home/${host_username}/Steam || exit
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

/home/${host_username}/Steam/steamcmd.sh +force_install_dir /home/${host_username}/sunkenland +login anonymous +@sSteamCmdForcePlatformType windows +app_update ${steam_app_id} validate +quit
