#!/bin/sh

#set -e
#set -x

. /init/output.sh

export NODE_ENV=${NODE_ENV:-production}

QUASSEL_HOST=${QUASSEL_HOST:-localhost}
QUASSEL_PORT=${QUASSEL_PORT:-4242}
FORCE_DEFAULT=${FORCE_DEFAULT:-false}
WEBSERVER_MODE=${WEBSERVER_MODE:-http}
WEBSERVER_PORT=${WEBSERVER_PORT:-64080}
PREFIX_PATH=${PREFIX_PATH:-''}

stdbool() {

  if [ -z "$1" ]
  then
    echo "n"
  else
    echo ${1:0:1} | tr '[:upper:]' '[:lower:]'
  fi
}

check_data_directory() {

  for d in $(pwd) $(pwd)/ssl
  do
    if [ $(whoami) != $(stat -c %G ${d}) ]
    then
      log_error "wrong permissions for directory."
      log_error "the quassel user can't write into ${d}."

      exit 1
    fi
  done

#  stat -c %G ${CONFIG_DIR}
#  stat -c %A ${CONFIG_DIR}
#  stat -c %a ${CONFIG_DIR}

  set -e
  touch $(pwd)/ssl/.keep
}

create_certificate() {

  [ -d ssl ] || mkdir ssl 2> /dev/null

  # generate key
  if [ ! -f ssl/key.pem ] || [ ! -f ssl/cert.pem ]
  then
    log_info "create certificate"

    openssl req \
      -x509 \
      -nodes \
      -days 365 \
      -newkey rsa:2048 \
      -keyout ssl/key.pem \
      -out ssl/cert.pem \
      -subj "/CN=Quassel-web"
  fi
}

create_config() {

  log_info "create settings-user.js"

  if [ $(stdbool ${FORCE_DEFAULT}) = "y" ]
  then
    FORCE_DEFAULT="true"
  else
    FORCE_DEFAULT="false"
  fi

  cat << EOF > settings-user.js

module.exports = {
  default: {
    host: '$QUASSEL_HOST',
    port: $QUASSEL_PORT
  },
  forcedefault: ${FORCE_DEFAULT},
  prefixpath: '${PREFIX_PATH}'
};

EOF

}

run() {

  check_data_directory

  create_certificate

  create_config

  if [ "${WEBSERVER_MODE}" = "https" ]
  then
    WEBSERVER_PORT=64443
  fi

#  Usage: app [options]
#
#    Options:
#
#      -h, --help            output usage information
#      -V, --version         output the version number
#      -c, --config <value>  Path to configuration file
#      -s, --socket <path>   listen on local socket. If this option is set, --listen, --port and --mode are ignored
#      -l, --listen <value>  listening address [0.0.0.0]
#      -p, --port <value>    http(s) port to use [64080|64443]
#      -m, --mode <value>    http mode (http|https) [https]

  node app.js \
    --version

  node app.js \
    --mode ${WEBSERVER_MODE} \
    --port ${WEBSERVER_PORT}
}

run
