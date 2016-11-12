#!/bin/bash
set -euo pipefail
. /dgr/bin/functions.sh
isLevelEnabled "debug" && set -x

set +e

# The baseimage should've taken care of this; doing it twice does no harm.
apt-get clean
rm -r /var/lib/apt/lists/* /tmp/* /var/tmp/* || true

# You can delete this on leaf images only.
rm -r /var/cache/debconf /var/lib/dpkg /usr/share/debhelper

# The usual.
rm -r /usr/share/{man,doc}

# If run as 'root' steamcmd writes its log here.
rm -r /root/Steam/logs
ln -s /opt/steam/Steam/logs /root/Steam/logs

exit 0
