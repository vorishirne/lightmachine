#!/bin/sh
#NOTE: this is how I deal with my use-case, ur usecase will definitely be different though similar
# as there are problems with systemd for cgroups v2, we have to rely on our own setup
set -ex

USERNAME=${1:-velcrine}
PASSWORD=${2:-" "}
LM_HOSTNAME=${LM_HOSTNAME:-envoy}

#this id 133 is the gid of groups on my "host" machine. change it to yours, e.g. in "getent group docker"
groupadd -g ${HOST_DOCKER_GID:-"133"} dockerengine
groupadd -g ${HOST_RENDER_GID:-"109"} render
useradd -u 1000 -d /home/$USERNAME -G sudo,dockerengine,render,video -m -p "$(openssl passwd -1 "$PASSWORD")" -s /bin/bash $USERNAME
#disable lecture to user on doing sudo first time
mkdir -p /var/lib/sudo/lectured/$USERNAME

service ssh start
service docker start

#yes same psycotic dream
git add -A
git commit -am "init"

cd /home/$USERNAME;

# this is the key command as it starts the actual GUI desktop environment
sudo -u velcrine startlxde

: '
we can run it this way, giving docker-engine access, and container net capacity as envoy and zap both come to use iptables

docker run --rm -ti --init \
 --cap-add NET_ADMIN --cap-add NET_RAW --init\
 --ipc=host\
 -e DISPLAY="172.17.0.1:8" -e PULSE_SINK=audio_jack3 -e PULSE_SERVER=tcp:172.17.0.1:12322 \
 -v /var/run/docker.sock:/var/run/docker.sock \
 -v /shared/pkv/d:/shared/velcrine/d \
 -v /shared/pkv/l:/shared/velcrine/l \
 -v /shared/pkv/p:/shared/velcrine/p:ro \
 -v /shared/pkv/r:/shared/velcrine/r \
 -v /shared/pkv/h/envoy:/home/ \
 --hostname envoy \
 velcrine/zap

 Xephyr -ac -noreset -dpi 96   -resizeable   -noxv   -screen 1504x804 -keybd ephyr,,,xkbmodel=evdev :8 -listen tcp   -retro   +extension RANDR   +extension RENDER   +extension GLX   +extension XVideo   +extension DOUBLE-BUFFER   +extension SECURITY   +extension DAMAGE   +extension X-Resource   -extension XINERAMA -xinerama   -extension MIT-SHM   +extension Composite +extension COMPOSITE   -extension XTEST -tst -dpms -s off
'