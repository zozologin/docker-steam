#!/bin/bash
set -euo pipefail
. /dgr/bin/functions.sh
isLevelEnabled "debug" && set -x

# Needed by steamcmd's contents.
apt-get -q update
apt-get -y install lib32stdc++6 libcurl3 libcurl3-boringssl

echo_green "Now comes steamcmd itself."
mkdir -p /opt/steam /var/lib/steam
# UID=GID=1000 is the next, that is a given with the baseimage.
adduser --disabled-password --no-create-home --gecos 'Steam console client' --home /opt/steam steam
curl --silent --show-error --fail --location \
  --header "Accept: application/tar+gzip, application/gzip, application/octet-stream" \
  https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
| tar --no-same-owner -xz -C /opt/steam/
chown -R steam:steam /var/lib/steam
chown -R steam:steam /opt/steam
find /opt/steam -name 'steamcmd' -type f -exec chmod 0755 '{}' \;
