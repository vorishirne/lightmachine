#Examples for custom lightmachine

Here we have an script setup to build applications, that extend the base desktop environment files.
After setting up the base structure, all that needs to be done is to add one more function in `install_tool.sh` under the switch condition.
For ex, 
* Just passing `--build-arg LM_TOOL=zap` to docker build, it will build the image for owasp-zap.
* Similarly, `--build-arg LM_TOOL=envoy` to docker build, it will build the image for Envoy proxy.

Complete command will look like `docker build . -t velcrine/zap --build-arg LM_TOOL=zap --build-arg BUILD_WITH_IMAGE=velcrine/debian_lxde`

Note: this init.sh is for my use-case, which is " software development in local-machine", hence passwords are exposed too wide open. In your case, you might want to set password during runtime instead.