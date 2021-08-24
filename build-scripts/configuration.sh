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
wallpaper=/dockerstation/wallpaper.jpg
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

  echo "startlxde" >>/dockerstation/run-scripts/desktopenv.sh

}

lxqt(){
  # set theme icons and font; must for lxqt
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

# set wallpaper and properties
mkdir -p /etc/skel/.config/pcmanfm-qt/lxqt
echo '
[Desktop]
ShowHidden=true
Wallpaper=/dockerstation/wallpaper.jpg
WallpaperMode=stretch
' >/etc/skel/.config/pcmanfm-qt/lxqt/settings.conf

# add quicklaunch for terminal
echo "
[quicklaunch]
alignment=Left
apps\1\desktop=/usr/share/applications/qterminal_drop.desktop
apps\2\desktop=/usr/share/applications/qlipper.desktop
apps\size=2
type=quicklaunch
" >  /etc/skel/.config/lxqt/panel.conf

#qterminal shortcuts
mkdir -p /etc/skel/.config/qterminal.org/
echo '
[General]
AskOnExit=false

[Shortcuts]
Copy%20Selection="Ctrl+Shift+C, Ctrl+X"
Paste%20Clipboard="Ctrl+Shift+V, Ctrl+V"
' > /etc/skel/.config/qterminal.org/qterminal.ini

echo "
[General]
__userfile__=true
blackList=lxqt-panel
placement=top-right
server_decides=1" > /etc/skel/.config/lxqt/notifications.conf

echo "startlxqt" >>/dockerstation/run-scripts/desktopenv.sh
}


gnome() {

  #starting dbus; it supresses some warnings during running gnome-session
  dbus-uuidgen >/var/lib/dbus/machine-id
  mkdir -p /var/run/dbus
  dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address

  echo "gnome-session" >>/dockerstation/run-scripts/desktopenv.sh
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
  mkdir /dockerstation/run-scripts
  mkdir -p /etc/skel/.config/
  mkdir -p /etc/skel/Desktop/
  sh -c 'echo "*.log\n" >/etc/skel/.gitignore'

  echo "#!/bin/sh
  set -ex
#  user can attach his own init.sh using docker's -v flag.
#  but strict note must be followed that it should only follow the pattern in original init.sh
# for custom or additional setup use app-init.sh as done below
  [ -e /dockerstation/run-scripts/init.sh ] && . /dockerstation/run-scripts/init.sh" > /dockerstation/run-scripts/entrypoint.sh


  echo "
#  user can provide any script here to create env for target app during init time
  [ -e /dockerstation/run-scripts/app-init.sh ] && . /dockerstation/run-scripts/app-init.sh" >> /dockerstation/run-scripts/entrypoint.sh

  echo 'sudo -u ${USERNAME} sh /dockerstation/run-scripts/desktopenv.sh' >> /dockerstation/run-scripts/entrypoint.sh
  chmod a+x /dockerstation/run-scripts/entrypoint.sh
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
  editor=featherpad
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
