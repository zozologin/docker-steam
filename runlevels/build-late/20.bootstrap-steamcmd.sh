#!/bin/bash
set -euo pipefail
. /dgr/bin/functions.sh
isLevelEnabled "debug" && set -x

# This bootstraps the Steam console client.
cd /opt/steam
chpst -u steam -- \
/opt/steam/steamcmd.sh +login anonymous validate +quit

# Allows steamcmd to update itself as unprivileged user.
chown -R steam:steam /opt/steam

# Gets the client's version so we can identify it for Valve to properly report errors.
version=$(</opt/steam/package/steam_cmd_linux.manifest grep -m 1 -A 3 -F '"linux"' | grep -F version | awk '{print $2}')
echo_purple "This is steamcmd version: ${version}"
cat >/dgr/builder/attributes/steamcmd.yml <<EOF
default:
  steamcmd:
    version: ${version}
EOF
