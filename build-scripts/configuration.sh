#!/bin/sh
# here, we just provide configs for installed packages
set -ex

lxde() {
  #bug in lxpolkit, it says "session not found for pid of lxpolkit" https://github.com/meefik/linuxdeploy/issues/978
  mv /usr/bin/lxpolkit /usr/bin/lxpolkit.bak
  mkdir -p /etc/skel/.config/pcmanfm/LXDE/
echo "
[*]
wallpaper_mode=stretch
wallpaper_common=1
wallpaper=/dockerstation/wallpaper.png
" >/etc/skel/.config/pcmanfm/LXDE/desktop-items-0.conf

echo '[Added Associations]
text/plain=mousepad.desktop;
' >/etc/skel/.config/mimeapps.list

echo "
[Desktop Entry]
Type=Link
Name=LXTerminal
Icon=lxterminal
URL=/usr/share/applications/lxterminal.desktop
" >/etc/skel/Desktop/lxterminal.desktop

  echo "startlxde" >>/usr/local/bin/start

}

lxqt(){
  mkdir -p /etc/skel/.config/lxqt
echo '
[General]
__userfile__=true
icon_theme=Adwaita
single_click_activate=false
theme=ambiance
tool_button_style=ToolButtonTextBesideIcon

[Qt]
doubleClickInterval=400
font="Sans,11,-1,5,50,0,0,0,0,0"
style=Fusion
wheelScrollLines=3
' >/etc/skel/.config/lxqt/lxqt.conf

mkdir -p /etc/skel/.config/pcmanfm-qt/lxqt
echo '
[Desktop]
ShowHidden=true
Wallpaper=/dockerstation/wallpaper.png
WallpaperMode=stretch
' >/etc/skel/.config/pcmanfm-qt/lxqt/settings.conf

sed -i -r \
-e 's/Name=(.*)$/Name=cmd/' \
-e 's/GenericName=(.*)$/GenericName=/' \
/usr/share/applications/qterminal_drop.desktop

echo '
[quicklaunch]
alignment=Left
apps\\1\desktop=/usr/share/applications/qterminal_drop.desktop
apps\size=1
type=quicklaunch
' >> /etc/xdg/lxqt/panel.conf

echo "startlxqt" >>/usr/local/bin/start
}
gnome() {

  #starting dbus; it supresses some warnings during running gnome-session
  dbus-uuidgen >/var/lib/dbus/machine-id
  mkdir -p /var/run/dbus
  dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address

  echo "gnome-session" >>/usr/local/bin/start
}

node() {
  #keep image updated, as probably it is going to be used out of the box for development or debugging
  apt-get update

  # shipping with atleast a user to start with, if entrypoint is overriden
  useradd -u 9998 -d /home/debug -G sudo -m -p "$(openssl passwd -1 " ")" -s /bin/bash debug
  #creating a user with name "node" and password " "
  echo 'useradd -u 9999 -d /home/node -G sudo -m -p "$(openssl passwd -1 " ")" -s /bin/bash node' >> /usr/local/bin/start
  echo "cd /home/node; sudo -u node /bin/bash" >>/usr/local/bin/start
}

common_config() {
  mkdir -p /etc/skel/.config/
  mkdir -p /etc/skel/Desktop/


  wget https://raw.githubusercontent.com/velcrine/lightmachine.dockerfile/master/static/wallpaper.png \
    -O /dockerstation/wallpaper.png

  echo "#!/bin/sh
#  user can provide any script here to be executed at init time
  [ -e /dockerstation/init.sh ] && bash -ex /dockerstation/init.sh" >/usr/local/bin/start

  chmod a+x /usr/local/bin/start
  # haha it just works
  rm -r /dockerstation/build-scripts
}

case "${1}" in

"gnome3")
  common_config
  gnome
  editor=gedit
  ;;
"lxqt")
  common_config
  lxqt
  editor=mousepad
  ;;
"lxde")
  common_config
  lxde
  editor=mousepad
  ;;
"node")
  common_config
  node
  editor=nano
  ;;
*)
  echo "$0 [gnome3 | lxde | node]"
  exit 1
  ;;
esac
echo "EDITOR=$editor" >/etc/environment
