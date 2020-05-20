#!/bin/sh

CURL_OPTS="--silent --fail --head"

WEBSERVER_PORT=${WEBSERVER_PORT:-64080}
QUASSELWEB_PREFIX_PATH=${QUASSELWEB_PREFIX_PATH:-/}
PROTO=http

if [ "${WEBSERVER_MODE}" = "https" ]
then
  WEBSERVER_PORT=64443
  PROTO=https
  CURL_OPTS="${CURL_OPTS} --insecure"
fi

if curl ${CURL_OPTS} "${PROTO}://127.0.0.1:${WEBSERVER_PORT}${QUASSELWEB_PREFIX_PATH}"
then
  exit 0
fi

exit 1
