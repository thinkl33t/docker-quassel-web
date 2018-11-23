#!/bin/sh

set -e

export NODE_ENV=production

QUASSEL_HOST=${QUASSEL_HOST:-localhost}
QUASSEL_PORT=${QUASSEL_PORT:-4242}
FORCE_DEFAULT=${FORCE_DEFAULT:-false}
WEBSERVER_MODE=${WEBSERVER_MODE:-http}
PREFIX_PATH=${PREFIX_PATH:-''}

# PREFIX_PATH="/irc"

if [[ "${WEBSERVER_MODE}" == "https" ]] && [[ ! -e ssl/key.pem ]]
then
  openssl \
    req -x509 \
    -newkey rsa:2048 \
    -keyout ssl/key.pem \
    -out ssl/cert.pem \
    -nodes \
    -subj "/C=GB/ST=London/L=London/O=Quassel Webserver/OU=Quassel Webserver/CN=quassel-webserver.com"
fi

cat << EOF >> settings-user.js

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

# echo "module.exports = { default: { host: '$QUASSEL_HOST', port: $QUASSEL_PORT }, forcedefault: $FORCE_DEFAULT, prefixpath: '', theme: 'default'  };" > /data/quassel-webserver/settings.js

node app.js \
  -m ${WEBSERVER_MODE} \
  -p 64080
