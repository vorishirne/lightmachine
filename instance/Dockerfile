#to build
# docker build . -t velcrine/envoy --build-arg LM_TOOL=envoy --build-arg BUILD_WITH_IMAGE=velcrine/debian-lxqt

ARG BUILD_WITH_IMAGE
FROM $BUILD_WITH_IMAGE

ARG DEBIAN_FRONTEND=noninteractive
ARG LM_TOOL=envoy
ENV LM_TOOL $LM_TOOL
LABEL lm_tool=$LM_TOOL

WORKDIR /dockerstation/build-scripts

# good for debugging
RUN apt-get update
ADD resource/packages.sh /dockerstation/build-scripts/app-packages.sh
RUN bash -ex app-packages.sh user_tools
ADD resource/install_tool.sh /dockerstation/build-scripts/
RUN bash -ex install_tool.sh $LM_TOOL

ADD resource/init.sh /dockerstation/run-scripts/app-init.sh