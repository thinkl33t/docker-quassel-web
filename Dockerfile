
FROM alpine:3.9 as builder

ARG VCS_REF
ARG BUILD_DATE
ARG BUILD_VERSION
ARG BUILD_TYPE
ARG QUASSELWEB_VERSION

ENV \
  TERM=xterm \
  QUASSEL_HOST=localhost \
  QUASSEL_PORT=4242 \
  FORCE_DEFAULT=true \
  WEBSERVER_MODE=http \
  WEBSERVER_PORT=64080

# ---------------------------------------------------------------------------------------

RUN \
  apk update  --quiet && \
  apk upgrade --quiet && \
  apk add     --quiet \
    build-base \
    curl \
    git \
    nodejs-npm \
    nodejs \
    openssl \
    python

WORKDIR /data

RUN \
  git clone https://github.com/magne4000/quassel-webserver.git

WORKDIR quassel-webserver

RUN \
  if [ "${BUILD_TYPE}" == "stable" ] ; then \
    echo "switch to stable Tag v${QUASSELWEB_VERSION}" && \
    git checkout tags/${QUASSELWEB_VERSION} 2> /dev/null ; \
  else \
    version=$(git describe --tags --always | sed 's/^v//') && \
    echo "  version: ${version}" ; \
  fi

#RUN \
#  npm i -g npm && \
#  npm i --package-lock-only && \
#  npm install acorn && \
#  npm install --production
#
#RUN \
#  npm ls -gp --depth=0 | awk -F/node_modules/ '{print $2}' | grep -vE '^(npm|)$' | xargs -r npm -g rm && \
#  rm -rf \
#    /data/quassel-webserver/.git* && \
#  find \
#    . -type f -iname "*.md" -delete && \
#  find \
#    . -type f -iname "Makefile" -delete && \
#  find \
#    . -type f -iname ".travis.yml" -delete && \
#  find \
#    . -type f -iname ".npmignore" -delete && \
#  find \
#    . -type f -iname ".jshintrc" -delete && \
#  find \
#    . -type f -iname "yarn.lock" -delete && \
#  find \
#    . -type f -iname "*CONTRIBUTING*" -delete
#
## ---------------------------------------------------------------------------------------
#
#FROM alpine:3.9
#
#RUN \
#  apk update  --quiet --no-cache && \
#  apk upgrade --quiet --no-cache && \
#  apk add --no-cache \
#    ca-certificates \
#    nodejs \
#    openssl && \
#  rm -rf \
#    /tmp/* \
#    /root/.n* \
#    /var/cache/apk/*
#
#COPY --from=builder /data/quassel-webserver /data/quassel-webserver
#
#COPY rootfs/ /
#
#VOLUME ["/data/quassel-webserver/ssl"]
#WORKDIR /data/quassel-webserver
#
#CMD ["/init/run.sh"]
#
## ---------------------------------------------------------------------------------------
#
#EXPOSE 64080
#
#LABEL \
#  version=${BUILD_VERSION} \
#  maintainer="Bodo Schulz <bodo@boone-schulz.de>" \
#  org.label-schema.build-date=${BUILD_DATE} \
#  org.label-schema.name="Quassel Webserver Docker Image" \
#  org.label-schema.description="Inofficial Quassel Webserver Docker Image" \
#  org.label-schema.vcs-ref=${VCS_REF} \
#  org.label-schema.url="https://github.com/magne4000/quassel-webserver" \
#  org.label-schema.vcs-url="https://github.com/bodsch/docker-quassel-web" \
#  org.label-schema.vendor="Bodo Schulz" \
#  org.label-schema.version=${ICINGA_VERSION} \
#  org.label-schema.schema-version="1.0" \
#  com.microscaling.docker.dockerfile="/Dockerfile" \
#  com.microscaling.license="GNU General Public License v3.0"
#
#
