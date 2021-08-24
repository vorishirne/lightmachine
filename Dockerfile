# docker buildx build . -t velcrine/debian-lxqt --build-arg DESKTOP_ENV=lxqt
FROM ubuntu:20.04
WORKDIR /dockerstation/build-scripts

ARG DEBIAN_FRONTEND=noninteractive
ARG DESKTOP_ENV=lxde

ENV DESKTOP_ENV $DESKTOP_ENV
ENV NO_AT_BRIDGE 1
LABEL desktop=$DESKTOP_ENV


#to have just one compressed layer, as base desktop env image is not intended to rebuild often
#ADD build-scripts /dockerstation/build-scripts
#RUN apt-get update && \
#    sh environment.sh $DESKTOP_ENV && \
#    sh packages.sh general && \
#    sh clear.sh apt && \
#    sh configuration.sh $DESKTOP_ENV


#while during experimentation, this is better
RUN apt-get update
ADD build-scripts/packages.sh /dockerstation/build-scripts/
RUN bash -ex packages.sh general
ADD build-scripts/environment.sh /dockerstation/build-scripts/environment.sh
RUN bash -ex environment.sh $DESKTOP_ENV;
ADD build-scripts/configuration.sh /dockerstation/build-scripts/
RUN bash -ex configuration.sh $DESKTOP_ENV

WORKDIR ../run-scripts
ADD run-scripts/post-setup.sh /dockerstation/run-scripts/
ARG GITSETUP=false
RUN bash -ex post-setup.sh git $GITSETUP

ADD run-scripts/init.sh /dockerstation/run-scripts/

ENTRYPOINT ["bash","-ex","/dockerstation/run-scripts/entrypoint.sh"]