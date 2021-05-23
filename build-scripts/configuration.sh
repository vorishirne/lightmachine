#!/bin/sh
# here, we just provide configs for installed packages
set -ex

lxde() {
  #bug in lxde, it says "session not found for pid of lxpolkit" https://github.com/meefik/linuxdeploy/issues/978
  mv /usr/bin/lxpolkit /usr/bin/lxpolkit.bak

  mkdir -p /etc/skel/.config/pcmanfm/LXDE/
  #because we want wallpaper to be provided at runtime instead of build time
  echo '
echo "
[*]
wallpaper_mode=stretch
wallpaper_common=1
wallpaper=/dockerstation/${LM_WALLPAPER:-wallpaper.jpg}
" >/etc/skel/.config/pcmanfm/LXDE/desktop-items-0.conf
' >>/usr/local/bin/start

  echo "startlxde" >>/usr/local/bin/start

}

gnome() {

  #starting dbus; some applications just demand dbus to work; also it supresses some gnome-warnings
  dbus-uuidgen >/var/lib/dbus/machine-id
  mkdir -p /var/run/dbus
  dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address

  #gnome wants them to be manually generated to save space
  echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen
  locale-gen

  echo "gnome-session" >>/usr/local/bin/start
}

common_config() {
  echo $DESKTOP_ENV
  echo "#!/bin/sh" >/usr/local/bin/start
  chmod a+x /usr/local/bin/start
  rm -r /dockerstation/build-scripts
}

case "${1}" in

"gnome3")
  common_config
  gnome
  ;;
"lxde")
  common_config
  lxde
  ;;
*)
  echo "$0 [gnome3 | lxde ]"
  exit 1
  ;;
esac
