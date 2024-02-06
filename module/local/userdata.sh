#!/bin/bash
set -e

dpkg --add-architecture i386
apt update
apt install -y \
    awscli \
    ca-certificates \
    jq \
    lib32gcc1 \
    lib32stdc++6 \
    libjson-c-dev \
    libsdl2-2.0-0:i386 \
    libtool \

cd /tmp
curl -s https://my-netdata.io/kickstart-static64.sh > kickstart-static64.sh
bash kickstart-static64.sh --dont-wait

useradd -m ${username}
su - ${username} -c "mkdir -p /home/${username}/sunkenland"

aws s3 cp s3://${bucket}/install_sunkenland.sh /home/${username}/sunkenland/install_sunkenland.sh
aws s3 cp s3://${bucket}/bootstrap_sunkenland.sh /home/${username}/sunkenland/bootstrap_sunkenland.sh
aws s3 cp s3://${bucket}/sunkenland.service /home/${username}/sunkenland/sunkenland.service

chmod +x /home/${username}/sunkenland/install_sunkenland.sh
chmod +x /home/${username}/sunkenland/bootstrap_sunkenland.sh

chown ${username}:${username} /home/${username}/sunkenland/install_sunkenland.sh
chown ${username}:${username} /home/${username}/sunkenland/bootstrap_sunkenland.sh
chown ${username}:${username} /home/${username}/sunkenland/sunkenland.service

cp /home/${username}/sunkenland/sunkenland.service /etc/systemd/system

su - ${username} -c "bash /home/${username}/sunkenland/install_sunkenland.sh"

systemctl daemon-reload
systemctl enable sunkenland.service
systemctl restart sunkenland
