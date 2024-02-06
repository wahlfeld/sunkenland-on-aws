#!/bin/bash
set -e

echo "Syncing startup script"

aws s3 cp s3://${bucket}/start_sunkenland.sh /home/${username}/sunkenland/start_sunkenland.sh
chmod +x /home/${username}/sunkenland/start_sunkenland.sh

bash /home/${username}/sunkenland/start_sunkenland.sh
