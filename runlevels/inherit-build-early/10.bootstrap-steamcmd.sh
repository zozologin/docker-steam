#!/bin/bash
set -euo pipefail
. /dgr/bin/functions.sh
isLevelEnabled "debug" && set -x

# This updates steamcmd if necessary.
if [[ -e /opt/steam/steamcmd.sh ]]; then
  /opt/steam/steamcmd.sh +login anonymous validate +quit
fi
