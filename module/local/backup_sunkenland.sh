#!/bin/bash
set -euo pipefail

# Put this back in the sunkenland service file
# ExecStopPost=${game_dir}/backup_sunkenland.sh

echo "Backing up Sunkenland world data"

echo "TODO: Determine path(s) for world data"
# aws s3 cp "${game_dir}/Worlds/${world_guid}.fwl" s3://${bucket}/
