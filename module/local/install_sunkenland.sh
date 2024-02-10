#!/bin/bash
set -e

echo "Installing Sunkenland server"

mkdir -p /home/${host_username}/steam && cd /home/${host_username}/steam || exit
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

/home/${host_username}/steam/steamcmd.sh +force_install_dir /home/${host_username}/sunkenland +login ${steam_username} ${steam_password} +app_update ${steam_app_id} validate +quit
