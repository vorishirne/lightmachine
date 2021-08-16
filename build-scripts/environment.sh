#!/bin/sh
# installs only the desktop environments and their specific packages
set -ex

gnome() {
  apt-get install --no-install-recommends -y \
    gnome-session \
    cheese gedit gnome-control-center gnome-system-monitor \
    gnome-terminal gnome-tweaks nautilus

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
    '
}

lxde() {
  apt-get install --no-install-recommends -y \
    lxde lxlauncher lxtask
  true '
  lxde: ligtweight x11 desktop environment
  lxlauncher : launcher that pops up pressing Windows key in lxde
  lxtask : task manager for lxde
  '
}

lxqt(){
  apt-get install --no-install-recommends -y \
  lxqt-core qtwayland5 xfwm4 \
  featherpad lxqt-about lxqt-config lxqt-qtplugin \
  pavucontrol-qt qlipper qterminal
}

case "${1}" in

"gnome3")
  gnome
  ;;
"lxde")
  lxde
  ;;
"lxqt")
  lxqt
  ;;
"node")
  true
  ;;

*)
  echo "$0 [gnome3 | lxde | node ]"
  exit 1
  ;;
esac
