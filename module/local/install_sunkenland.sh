#!/bin/bash
set -euo pipefail

echo "Installing Sunkenland server"

mkdir -p /home/${host_username}/Steam && cd /home/${host_username}/Steam || exit
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

${install_update_cmd}
