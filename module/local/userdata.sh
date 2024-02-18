#!/bin/bash
set -euo pipefail

dpkg --add-architecture i386
apt update
apt install -y \
    awscli \
    ca-certificates \
    cabextract \
    jq \
    lib32gcc1 \
    lib32stdc++6 \
    libcurl4-openssl-dev:i386 \
    libjson-c-dev \
    libsdl2-2.0-0:i386 \
    libtool \
    wine \
    xvfb \

cd /tmp
curl -s https://my-netdata.io/kickstart-static64.sh > kickstart-static64.sh
bash kickstart-static64.sh --dont-wait

useradd -m ${host_username}
su - ${host_username} -c "mkdir -p ${game_dir}"

aws s3 cp s3://${bucket}/install_sunkenland.sh ${game_dir}/install_sunkenland.sh
aws s3 cp s3://${bucket}/bootstrap_sunkenland.sh ${game_dir}/bootstrap_sunkenland.sh
aws s3 cp s3://${bucket}/sunkenland.service ${game_dir}/sunkenland.service

chmod +x ${game_dir}/install_sunkenland.sh
chmod +x ${game_dir}/bootstrap_sunkenland.sh

chown ${host_username}:${host_username} ${game_dir}/install_sunkenland.sh
chown ${host_username}:${host_username} ${game_dir}/bootstrap_sunkenland.sh
chown ${host_username}:${host_username} ${game_dir}/sunkenland.service

cp ${game_dir}/sunkenland.service /etc/systemd/system

su - ${host_username} -c "bash ${game_dir}/install_sunkenland.sh"

systemctl daemon-reload
systemctl enable sunkenland.service
systemctl restart sunkenland
