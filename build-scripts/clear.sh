#!/bin/sh
# we used good naming convention for this file
set -ex


clear_apt() {
  env DEBIAN_FRONTEND=noninteractive apt-get autoremove -y
  apt-get clean
  find /var/lib/apt/lists -type f -delete
  find /var/cache -type f -delete
  find /var/log -type f -delete
  exit 0
}

case "${1}" in

"apt")
  clear_apt
  ;;
*)
  echo "$0 [apt]"
  exit 1
  ;;
esac
