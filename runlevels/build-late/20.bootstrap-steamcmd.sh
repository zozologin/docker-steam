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
