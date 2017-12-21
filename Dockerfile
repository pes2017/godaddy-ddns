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

RUN chmod 555 init.sh

CMD while /bin/true; do ./init.sh; /bin/sleep 60; done
