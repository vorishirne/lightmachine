#!/bin/sh
# install the envoy
set -ex

install_envoy() {
  curl -sL 'https://getenvoy.io/gpg' | apt-key add
  add-apt-repository "deb [arch=amd64] https://dl.bintray.com/tetrate/getenvoy-deb $(lsb_release -cs) stable"

  apt-get update
  apt-get install --no-install-recommends -y \
    getenvoy-envoy

  envoy --version
}

install_zap() {
  apt-get install --no-install-recommends -y \
    openjdk-11-jdk
  cookie=$(mcookie)
  wget -o /dev/null -O /var/tmp/zap$cookie https://github.com/zaproxy/zaproxy/releases/download/v2.10.0/ZAP_2_10_0_unix.sh
  sh /var/tmp/zap$cookie -q -splash
  mv /usr/local/bin/zap.sh /usr/local/bin/zap
}

case "${1}" in

"envoy")
  install_envoy
  ;;
"zap")
  install_zap
  ;;
*)
  echo "$0 [install]"
  exit 1
  ;;
esac
