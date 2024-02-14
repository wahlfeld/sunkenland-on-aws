#!/bin/bash
set -euo pipefail

# Put this back in the sunkenland service file
# ExecStopPost=/home/${host_username}/sunkenland/backup_sunkenland.sh

echo "Backing up Sunkenland world data"

echo "TODO: Determine path(s) for world data"
# aws s3 cp "/home/${host_username}/.config/unity3d/IronGate/sunkenland/worlds_local/${world_guid}.fwl" s3://${bucket}/
# aws s3 cp "/home/${host_username}/.config/unity3d/IronGate/sunkenland/worlds_local/${world_guid}.db" s3://${bucket}/
