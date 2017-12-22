
FROM alpine:3.7

EXPOSE 64080

ENV \
  TERM=xterm \
  BUILD_DATE="2017-12-22" \
  BUILD_TYPE="stable" \
  BUILD_VERSION="2.2.8" \
  QUASSEL_HOST=localhost \
  QUASSEL_PORT=4242 \
  FORCE_DEFAULT=true \
  WEBSERVER_MODE=http \
  WEBSERVER_PORT=64080

# ---------------------------------------------------------------------------------------

RUN \
  apk update --quiet --no-cache && \
  apk upgrade --quiet --no-cache && \
  apk add --quiet --no-cache --virtual .build-deps \
    build-base curl git python && \
  apk add --quiet --no-cache \
    nodejs \
    nodejs-npm \
    openssl && \
  mkdir /data && \
  cd /data && \
  git clone https://github.com/magne4000/quassel-webserver.git && \
  cd quassel-webserver && \
  if [ "${BUILD_TYPE}" == "stable" ] ; then \
    echo "switch to stable Tag v${BUILD_VERSION}" && \
    git checkout tags/${BUILD_VERSION} 2> /dev/null ; \
  fi && \
  npm install --production && \
  find . -type d -name "doc" -o -name "node_modules.old" -o -name "dist" -o -name "test" | xargs -r rm -rf && \
  find . -type f -iname "*.md" -o -iname "*.markdown" -o -iname "LICENSE*" | xargs -r rm -f && \
  npm ls -gp --depth=0 | awk -F/node_modules/ '{print $2}' | grep -vE '^(npm|)$' | xargs -r npm -g rm && \
  apk del --quiet .build-deps && \
  rm -rf \
    /tmp/* \
    /root/.n* \
    /data/quassel-webserver/.git* \
    /var/cache/apk/*

ADD rootfs/ /

WORKDIR /data/quassel-webserver

CMD ["/init/run.sh"]
