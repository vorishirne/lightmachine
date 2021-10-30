# LightMachine
### aka lighter virtual machine

Docker containers provide isolation, for process. Well rendering UI is also a process.
The blocker is, docker container images do not have the necessary drivers and hardware access to interact with the display device. To be specific, running an "Xorg" server is (inhumanely)impossible in docker.

### Hence, to render UI from docker, like below, we have to do someting like x11(xorg server) forwarding, like in `ssh -x`
<p>
<img src="https://github.com/vorishirne/lightmachine/raw/master/doc/img/screenshot-mate.jpeg" alt="feed example" width="500">
<img src="https://github.com/vorishirne/lightmachine/raw/master/doc/img/screenshot-xfce.jpeg" alt="feed example" width="500">
</p>

# Requirements
1. Nested Xserver: Xephyr
   1. Run with following configuration
      1. ```shell
         Xephyr -ac -noreset -dpi 96   -resizeable   -noxv   -screen 1504x804 -keybd ephyr,,,xkbmodel=evdev :8 -listen tcp   -retro   +extension RANDR   +extension RENDER   +extension GLX   +extension XVideo   +extension DOUBLE-BUFFER   +extension SECURITY   +extension DAMAGE   +extension X-Resource   -extension XINERAMA -xinerama   -extension MIT-SHM   +extension Composite +extension COMPOSITE   -extension XTEST -tst -dpms -s off
         ```
2. The lightmachine docker image,
    1. ```shell
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
        ```

# Dockerfile-build
One Dockerfile, built with --build-arg DESKTOP_ENV= gnome3 | lxde | mate | node will produce respective docker image. 
 
 `docker build . -t velcrine/debian_lxde --build-arg DESKTOP_ENV=lxde`
 
##### I highly recommend go through the build process and make your own customizations for your own flavour.
 1. `--build-arg DESKTOP_ENV=lxde` : to produce `velcrine/debian_lxde` which is based on "lxde" desktop environment
 2. `--build-arg DESKTOP_ENV=gnome3` : to produce `velcrine/debian_gnome3` which is based on "gnome3" desktop environment
 3. `--build-arg DESKTOP_ENV=mate` : to produce `velcrine/debian_mate` which is based on "mate" desktop environment
 4. `--build-arg DESKTOP_ENV=node` : to produce `velcrine/debian_node` which is based on "no desktop environment"(node).
        
    Node comes with a user named "debug", password " " and uid 9998 to begin with.
 
# Extending out
1. Add a shell script to be run (kind of as an entrypoint) before the desktop environment starts like this `-v /path/to/file.sh:/dockerstation/init.sh`. Now this shell script will run before the desktop environment starts.  

2. Use these images as base image for extending them with your application or your configuration. See `/instance` directory for live example. 
