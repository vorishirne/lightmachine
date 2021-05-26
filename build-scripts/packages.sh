#!/bin/sh
# install the additional packages required for smooth user experience
set -ex

#  non-mandatory but suggested packages
basic_utility_tools() {
  apt-get install --no-install-recommends -y \
    procps openssl git nano ssh  curl wget gnupg-agent ca-certificates gnupg software-properties-common lsb-release
  true '
  procps : ps command
  openssl : standard ssl library, which google copied and made into boring ssl; openssl is core of nginx, boringssl of envoy
  gnupg-agent : "apt-key add" command needs it
  gnupg : gives the gnu command which is used while installing packages
  ca-certificates : the ca bundle for tls ;)
  software-properties-common : add-apt-repository needed it
  (apt-transport-https is removed, which used to provide tls for apt)
  lsb-release : gives distro information
  '
}

#quite mandatory for smooth application execution
system_tools() {
  apt-get install --no-install-recommends -y \
    sudo locales

  if [ $DESKTOP_ENV != "node" ]; then
    apt-get install --no-install-recommends -y \
      dbus-x11 mesa-utils mesa-utils-extra libxv1

  fi

  if [ $DESKTOP_ENV = "gnome3" ]; then
    # not known where these packages come into picture
    apt-get install --no-install-recommends -y \
      x11-xserver-utils
  fi

  true '
    dbus-x11 : refernce implementation of dbus protocol, used for ipc in [gui] apps
    policykit-1-gnome : pop-up window asking for password, when requested by a process,
                        never saw it working in lxde though, as when doing "service start",
                        when non-sudo it shows that dialog in pc, but it didnt

    sudo : surprise it doesnt comes out of the box
    locales : ah, some language support package, bla
    mesa-utils mesa-utils-extra libxv1 : graphics drivers
    '
}

case "${1}" in

"basic")
  basic_utility_tools
  ;;
"system")
  system_tools
  ;;
"general")
  system_tools
  basic_utility_tools
  ;;
*)
  echo "$0 [utility | basic | system ]"
  exit 1
  ;;
esac
