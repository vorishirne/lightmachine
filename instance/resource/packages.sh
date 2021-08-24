#!/bin/sh
# install the additional packages required for smooth application experience
set -ex

user_tools() {
  #this way gives latest docker
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null
  apt-get update

  apt-get install --no-install-recommends -y \
    docker-ce docker-ce-cli

  if [ $DESKTOP_ENV != node ]; then
    gui_user_tools
  fi
}

gui_user_tools() {
  apt-get install --no-install-recommends -y \
    firefox
}

case "${1}" in
"user_tools")
  user_tools
  ;;
*)
  echo "$0 [user_tools]"
  exit 1
  ;;
esac
