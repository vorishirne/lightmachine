#!/bin/sh
# install the additional packages required for smooth user experience
set -ex


utility_tools() {
  net_tools
}

net_tools() {
  env DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    curl wget
}

basic_utility_tools() {
  env DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    procps
  true '
  procps : ps command
  '
}

system_tools() {
  env DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    policykit-1-gnome dbus-x11 \
    dbus x11-xserver-utils

  true '
    dbus-x11 : refernce implementation of dbus protocol, used for ipc
    policykit-1-gnome : pop-up window asking for password, when requested by a process
    dbus : this package was needed only for gnome3
    '
}

case "${1}" in

"utility")
  utility_tools
  ;;
"basic")
  basic_utility_tools
  ;;
"system")
  system_tools
  ;;
"general")
  system_tools
  basic_utility_tools
  utility_tools
  ;;
*)
  echo "$0 [utility | basic | system | at]"
  exit 1
  ;;
esac
