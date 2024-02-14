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
su - ${host_username} -c "mkdir -p /home/${host_username}/sunkenland"

aws s3 cp s3://${bucket}/install_sunkenland.sh /home/${host_username}/sunkenland/install_sunkenland.sh
aws s3 cp s3://${bucket}/bootstrap_sunkenland.sh /home/${host_username}/sunkenland/bootstrap_sunkenland.sh
aws s3 cp s3://${bucket}/sunkenland.service /home/${host_username}/sunkenland/sunkenland.service

chmod +x /home/${host_username}/sunkenland/install_sunkenland.sh
chmod +x /home/${host_username}/sunkenland/bootstrap_sunkenland.sh

chown ${host_username}:${host_username} /home/${host_username}/sunkenland/install_sunkenland.sh
chown ${host_username}:${host_username} /home/${host_username}/sunkenland/bootstrap_sunkenland.sh
chown ${host_username}:${host_username} /home/${host_username}/sunkenland/sunkenland.service

cp /home/${host_username}/sunkenland/sunkenland.service /etc/systemd/system

su - ${host_username} -c "bash /home/${host_username}/sunkenland/install_sunkenland.sh"

systemctl daemon-reload
systemctl enable sunkenland.service
systemctl restart sunkenland
