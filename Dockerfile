FROM alpine:latest

MAINTAINER Haocen.xu@gmail.com

RUN apk add --no-cache curl
RUN apk add --no-cache bash

WORKDIR /usr/scripts

COPY init.sh ./

ENV DOMAIN example.com
ENV NAME www
ENV KEY abcdef
ENV SECRET qwerty
ENV IP_DETECTOR_ENDPOINT https://api.ipify.org/

RUN chmod 555 init.sh

CMD while /bin/true; do ./init.sh; /bin/sleep 300; done
