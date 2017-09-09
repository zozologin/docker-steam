#!/bin/bash

set -euo pipefail
if [[ ! -z ${debug+x} ]]; then
  set -x
fi

V_BOLD_RED="\e[1m\e[0;31m"
V_BOLD_PURPLE="\e[1m\e[0;35m"
V_BOLD_GREEN="\e[1m\e[0;32m"
V_VIDOFF="\e[0m"

if [[ -t 1 ]] && tput colors &>/dev/null; then
  V_BOLD_RED=$(tput bold; tput setaf 1)
  V_BOLD_GREEN=$(tput bold; tput setaf 2)
  V_VIDOFF=$(tput sgr0)
fi

info() {
  printf "${V_BOLD_GREEN}${1}${V_VIDOFF}"
}
error() {
  >&2 printf "${V_BOLD_RED}${1}${V_VIDOFF}"
}

if [[ $EUID -ne 0 ]]; then
  error "Run this as 'root'.\n"
  exit 1
fi

: ${dgr:="/opt/sbin/dgr"}
if command -v dgr &>/dev/null; then
  dgr="$(command -v dgr)"
fi

info "Build the ACI file using dgr (usually takes about 10min):\n"
(${dgr} build)

# Compress.
info "The image has been built. Now comes its compressing: "
: ${version:="latest"}
if command -v jq &>/dev/null; then
  version="$(<target/manifest.json jq -r '.labels[0].value')"
fi
xz -9e --stdout --threads=8 target/image.aci >steamcmd-${version}-linux-amd64.aci

info "Done. Enjoy!\n"
if [[ ! -z "${SUDO_UID}" ]]; then
  chown "${SUDO_UID}:${SUDO_GID}" steamcmd*.aci
fi
rm -rf target
exit 0
