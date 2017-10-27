
FROM alpine:latest

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

ENV \
  ALPINE_MIRROR="mirror1.hs-esslingen.de/pub/Mirrors" \
  ALPINE_VERSION="v3.6" \
  TERM=xterm \
  BUILD_DATE="2017-10-27" \
  BUILD_TYPE="stable" \
  BUILD_VERSION="2.2.8" \
  QUASSEL_HOST=localhost \
  QUASSEL_PORT=4242 \
  FORCE_DEFAULT=true \
  WEBSERVER_MODE=http \
  WEBSERVER_PORT=64080

EXPOSE 64080

# ---------------------------------------------------------------------------------------

ADD ./start.sh /start.sh

RUN \
  echo "http://${ALPINE_MIRROR}/alpine/${ALPINE_VERSION}/main"       > /etc/apk/repositories && \
  echo "http://${ALPINE_MIRROR}/alpine/${ALPINE_VERSION}/community" >> /etc/apk/repositories && \
  apk \
    --no-cache \
    update && \
  apk \
    --no-cache \
    upgrade && \
  apk \
    --no-cache \
    add nodejs-current nodejs-current-npm git openssl

RUN \
  mkdir /data && \
  cd /data && \
  git clone https://github.com/magne4000/quassel-webserver.git && \
  cd quassel-webserver && \
  #
  # build stable packages
  if [ "${BUILD_TYPE}" == "stable" ] ; then \
    echo "switch to stable Tag v${BUILD_VERSION}" && \
    git checkout tags/${BUILD_VERSION} 2> /dev/null ; \
  fi && \
  #
  npm install --production

RUN \
  rm -rf \
    /tmp/* \
    /var/cache/apk/*

ADD rootfs/ /

# FROM mhart/alpine-node
# MAINTAINER Joel Kaaberg <joel.kaberg@gmail.com>
#
# ENV
# ENV
# ENV FORCE_DEFAULT=true
# ENV WEBSERVER_MODE=http
# ENV WEBSERVER_PORT=64080
#
# ADD ./start.sh /start.sh
#
# RUN apk add --update --no-cache git openssl
#
# RUN mkdir /data && cd /data && git clone https://github.com/magne4000/quassel-webserver.git && cd quassel-webserver && cp settings.js settings-user.js && npm install --production
# RUN chmod +x /start.sh

WORKDIR /data/quassel-webserver

CMD ["/init/run.sh"]
