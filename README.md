# quassel-webserver

Dockerfile for [quassel-webserver](https://github.com/magne4000/quassel-webserver) by magne4000.

Forked from jakexks/dockerfiles with minor edits to work with newer quassel-webserver

A web client for Quassel (requires a running quasselcore)

## Usage

Out of the box, it provides a client that can connect to any quassel core.
Note that it always listens on port 64080 as this is the one exposed by the Dockerfile

```
docker run \
  -detach \
  --name quassel-webserver \
  --publish-all \
  bodsch/docker-quassel-web:2.2.8
```

Alternatively, you can specify advanced options by setting the following environment variables:

  * ```QUASSEL_HOST``` - the address of your quassel core (default localhost)
  * ```QUASSEL_PORT``` - the port it is listening on (default 4242)
  * ```FORCE_DEFAULT``` - Only allow connections to the above core (default false)
  * ```WEBSERVER_MODE``` - http or https (default https)
  * ```PREFIX_PATH``` - prefix Path (default '')

### Full example

```
docker run \
  --detach \
  --name quassel-webserver \
  --publish 8080:64080 \
  --env QUASSEL_HOST=localhost \
  --env QUASSEL_PORT=4242 \
  --env FORCE_DEFAULT=true \
  --env WEBSERVER_MODE=https \
  --env PREFIX_PATH=/irc \
  bodsch/docker-quassel-web:2.2.8
```
