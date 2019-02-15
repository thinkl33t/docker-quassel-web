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

create_certificate() {

  mkdir ssl 2> /dev/null

  # generate key
  if [ ! -f ssl/key.pem ] || [ ! -f ssl/cert.pem ]
  then
    log_info "create certificate"

    openssl \
      req -x509 \
      -newkey rsa:2048 \
      -keyout ssl/key.pem \
      -out ssl/cert.pem \
      -nodes
  fi
}

create_config() {

  log_info "create settings-user.js"

  cat << EOF > settings-user.js

module.exports = {
  default: {
    host: '$QUASSEL_HOST',               // quasselcore host
    port: $QUASSEL_PORT,                 // quasselcore port
    initialBacklogLimit: 20,             // Amount of backlogs to fetch per buffer on connection
    backlogLimit: 100,                   // Amount of backlogs to fetch per buffer after first retrieval
    securecore: true,                    // Connect to the core using SSL
    theme: 'default'                     // Default UI theme
  },
  themes: ['default', 'darksolarized'],  // Available themes
  forcedefault: $FORCE_DEFAULT,          // Will force default host and port to be used, and will hide the corresponding fields in the UI
  prefixpath: '${PREFIX_PATH}'           // Configure this if you use a reverse proxy
};

EOF

}

run() {

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
