#!/bin/sh

echo $NO_AT_BRIDGE

service docker start
: '
we can run it this way, giving docker-engine access, and container net capacity as envoy and zap both come to use iptables

docker run --rm -ti --init \
 --cap-add NET_ADMIN --cap-add NET_RAW --init\
 -e DOCKERGROUP=$(getent group docker | awk -F : '{ print $3 }') \
 -e RENDERGROUP=$(getent group render | awk -F : '{ print $3 }') \
 --ipc=host\
 -e DISPLAY="128.0.0.1:8" -e PULSE_SINK=audio_jack3 -e PULSE_SERVER=tcp:128.0.0.1:12322 \
 -v /var/run/docker.sock:/var/run/docker.sock \
 -v /shared/pkv/d:/shared/velcrine/d \
 -v /shared/pkv/l:/shared/velcrine/l \
 -v /shared/pkv/p:/shared/velcrine/p:ro \
 -v /shared/pkv/r:/shared/velcrine/r \
 -v /shared/pkv/h/envoy:/home/ \
 --hostname lxqt \
 -e USERNAME=velcrine \
 -e PASSWORD=ok \
 velcrine/envoy:latest

 Xephyr -ac -noreset -dpi 96   -resizeable   -noxv   -screen 1504x804 -keybd ephyr,,,xkbmodel=evdev :8 -listen tcp   -retro   +extension RANDR   +extension RENDER   +extension GLX   +extension XVideo   +extension DOUBLE-BUFFER   +extension SECURITY   +extension DAMAGE   +extension X-Resource   -extension XINERAMA -xinerama   -extension MIT-SHM   +extension Composite +extension COMPOSITE   -extension XTEST -tst -dpms -s off
'