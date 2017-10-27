
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

RUN \
  echo "http://${ALPINE_MIRROR}/alpine/${ALPINE_VERSION}/main"       > /etc/apk/repositories && \
  echo "http://${ALPINE_MIRROR}/alpine/${ALPINE_VERSION}/community" >> /etc/apk/repositories && \
  apk --quiet --no-cache update && \
  apk --quiet --no-cache upgrade && \
  apk --quiet --no-cache add \
    nodejs-current \
    nodejs-current-npm \
    git \
    openssl && \
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
  npm install --production && \
  find . -iname "*.md" -o -iname "*.markdown" -o -iname "LICENSE*"  | xargs -r rm

RUN \
  npm ls -gp --depth=0 | awk -F/node_modules/ '{print $2}' | grep -vE '^(npm|)$' | xargs -r npm -g rm && \
  apk --quiet --purge del git && \
  rm -rf \
    /tmp/* \
    /root/.n* \
    /data/quassel-webserver/.git* \
    /var/cache/apk/*

ADD rootfs/ /

WORKDIR /data/quassel-webserver

CMD ["/init/run.sh"]
