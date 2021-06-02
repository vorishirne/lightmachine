# LightMachine.dockerfile
Docker images for velcrine/lightmachine(an upcoming project) are baked here.  


One Dockerfile, built with --build-arg DESKTOP_ENV= gnome3 | lxde | mate | node will produce respective docker image. 
 
 `docker build . -t velcrine/debian_lxde --build-arg DESKTOP_ENV=lxde`
 
##### I highly recommend go through the build process and make your own customizations for your own flavour.
 1. `--build-arg DESKTOP_ENV=lxde` : to produce `velcrine/debian_lxde` which is based on "lxde" desktop environment
 2. `--build-arg DESKTOP_ENV=gnome3` : to produce `velcrine/debian_gnome3` which is based on "gnome3" desktop environment
 3. `--build-arg DESKTOP_ENV=mate` : to produce `velcrine/debian_mate` which is based on "mate" desktop environment
 4. `--build-arg DESKTOP_ENV=node` : to produce `velcrine/debian_node` which is based on "no desktop environment"(node).
        
    Node comes with a user named "node", password " " and uid 9999 out of the box.
 
# Extending out
1. Add a shell script to be run (kind of as an entrypoint) before the desktop environment starts like this `-v /path/to/file.sh:/dockerstation/init.sh`. Now this shell script will run before the desktop environment starts.  

2. Use these images as base image for extending them with your application or your configuration. See `/instance` directory for live example. 
