# docker build . -t velcrine/debian_lxde --build-arg DESKTOP_ENV=lxde
FROM debian:buster
WORKDIR /dockerstation/build-scripts

ARG DEBIAN_FRONTEND=noninteractive
ARG DESKTOP_ENV=lxde
ENV DESKTOP_ENV=$DESKTOP_ENV LANG="en_US.UTF-8" NO_AT_BRIDGE=1
LABEL lm_desktop=$DESKTOP_ENV


#to have just one compressed layer, as base desktop env image is not intended to rebuild often
ADD build-scripts /dockerstation/build-scripts
RUN apt-get update && \
    sh environment.sh $DESKTOP_ENV && \
    sh packages.sh general && \
    sh clear.sh apt && \
    sh configuration.sh $DESKTOP_ENV


#while during experimentation, this is better
#RUN apt-get update
#ADD build-scripts/environment.sh /dockerstation/build-scripts/environment.sh
#RUN sh environment.sh $DESKTOP_ENV;
#ADD build-scripts/packages.sh /dockerstation/build-scripts/
#RUN sh packages.sh general
#ADD build-scripts/configuration.sh /dockerstation/build-scripts/
#RUN sh configuration.sh $DESKTOP_ENV

WORKDIR ..

CMD /usr/local/bin/start