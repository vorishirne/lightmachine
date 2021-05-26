#!/bin/sh
# we used good naming convention for this file
set -ex


clear_apt() {
  apt-get autoremove -y
  apt-get clean
  find /var/lib/apt/lists -type f -delete
  find /var/cache -type f -delete
  find /var/log -type f -delete
  rm -rf /tmp/* /var/tmp/*
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
