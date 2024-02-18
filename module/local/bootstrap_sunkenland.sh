#!/bin/bash
set -euo pipefail

echo "Syncing startup script"

aws s3 cp s3://${bucket}/start_sunkenland.sh ${game_dir}/start_sunkenland.sh
chmod +x ${game_dir}/start_sunkenland.sh

bash ${game_dir}/start_sunkenland.sh
