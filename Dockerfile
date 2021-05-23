FROM debian:buster
WORKDIR /dockerstation/build-scripts

ARG DESKTOP_ENV=gnome3

#to have just one compressed layer, as base desktop env image is not intended to rebuild often

ADD build-scripts /dockerstation/build-scripts
RUN chmod -R a+x /dockerstation/build-scripts && \
    apt-get update && \
    ./environment.sh $DESKTOP_ENV && \
    ./packages.sh general && \
    ./clear.sh apt && \
    ./configuration.sh $DESKTOP_ENV


#while during experimentation, this is better

#RUN apt-get update
#ADD build-scripts/environment.sh /dockerstation/build-scripts/environment.sh
#RUN chmod -R a+x /dockerstation/build-scripts
#RUN ./environment.sh $DESKTOP_ENV;
#ADD build-scripts/packages.sh /dockerstation/build-scripts/
#RUN chmod -R a+x /dockerstation/build-scripts
#RUN ./packages.sh general
#ADD build-scripts/configuration.sh /dockerstation/build-scripts/
#RUN chmod -R a+x /dockerstation/build-scripts
#RUN ./configuration.sh $DESKTOP_ENV

#GNOME SPECIFIC
ENV LANG="en_US.UTF-8"
ENV NO_AT_BRIDGE=1

WORKDIR ..

CMD /usr/local/bin/start