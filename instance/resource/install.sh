#!/bin/sh
# install the additional packages required for smooth application experience
set -ex

git_root() {
  echo "/dockerstation\n/proc/\n/sys/\n/dev\n/tmp\n/var/tmp/\n/home\n/run" >>.gitignore
  git config --global user.email "velcrine@gmail.com"
  git config --global user.name "velcrine"
  git init
  git add -A
  git commit -am "initial" 1>/dev/null
}

clear() {
  apt-get autoremove -y
  apt-get clean
  find /var/lib/apt/lists -type f -delete
  find /var/cache -type f -delete
  find /var/log -type f -delete
  rm -rf /tmp/* /var/tmp/*
}

case "${1}" in
"clear")
  clear
  ;;
"commit")
  git_root
  ;;
*)
  echo "$0 [clear | commit]"
  exit 1
  ;;
esac
