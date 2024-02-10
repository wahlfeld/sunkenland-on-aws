#!/bin/bash
set -e

echo "Syncing startup script"

aws s3 cp s3://${bucket}/start_sunkenland.sh /home/${host_username}/sunkenland/start_sunkenland.sh
chmod +x /home/${host_username}/sunkenland/start_sunkenland.sh

bash /home/${host_username}/sunkenland/start_sunkenland.sh
