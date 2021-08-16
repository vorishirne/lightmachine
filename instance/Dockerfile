#to build
# docker build . -t velcrine/zap --build-arg LM_TOOL=zap --build-arg BUILD_WITH_IMAGE=velcrine/debian_lxde

#run as
# docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock velcrine/zap
ARG BUILD_WITH_IMAGE=velcrine/debian_lxde
FROM $BUILD_WITH_IMAGE

ARG DEBIAN_FRONTEND=noninteractive
ARG LM_TOOL=envoy
ENV LM_TOOL $LM_TOOL
LABEL lm_tool=$LM_TOOL

WORKDIR /dockerstation/build-scripts

# for one compressed layer
#ADD resource/install.sh resource/install_tool.sh resource/packages.sh  /dockerstation/build-scripts/
#RUN apt-get update &&\
#    sh packages.sh user_tools &&\
#    sh install_tool.sh $LM_TOOL &&\
#    sh install.sh clear &&\
#    apt-get update


# good for debugging
RUN apt-get update
ADD resource/packages.sh /dockerstation/build-scripts/
RUN sh packages.sh user_tools
ADD resource/install_tool.sh /dockerstation/build-scripts/
RUN sh install_tool.sh $LM_TOOL
ADD resource/install.sh /dockerstation/build-scripts/


WORKDIR /
#a psychotic hobby
RUN sh /dockerstation/build-scripts/install.sh commit

RUN rm -r /dockerstation/build-scripts/

RUN echo "shared/" >> .gitignore
ADD resource/init.sh /dockerstation/
ENTRYPOINT ["sh","/dockerstation/init.sh"]
