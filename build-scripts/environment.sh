#!/bin/sh
# installs only the desktop environments and their specific packages
set -ex

gnome() {
  env DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    gnome-session \
    cheese gedit gnome-control-center gnome-system-monitor \
    gnome-terminal gnome-tweaks nautilus \
    \
    locales

  true '
    locales : necessary for some apps in gnome to obtain language neutrality
    gnome-session : gnome3 itself
    gedit : text editor
    cheese : application to access web cam
    gnome-control-center : core control center, gives gui control over all system utilities
    gnome-system-monitor : task manager for gnome
    gnome-terminal: standard gnome terminal
    gnome-tweaks : modify gnome configuration via gui
    nautilus : file manager
    gnome-shell-extension* : it adds control to the gnome-tweaks \
    such as one here https://i2.wp.com/itsfoss.com/wp-content/uploads/2017/11/enableuser-themes-extension-gnome.jpeg?w=800&ssl=1
    '
}

lxde() {
  env DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    lxde lxlauncher lxtask
  true '
  lxde: lxde itself
  lxlauncher : launcher that pops up pressing Windows key in lxde
  lxtask : task manager for lxde
  '
}

case "${1}" in

"gnome3")
  gnome
  ;;
"lxde")
  lxde
  ;;
*)
  echo "$0 [gnome3 | lxde ]"
  exit 1
  ;;
esac
