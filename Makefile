export GIT_SHA1          := $(shell git rev-parse --short HEAD)
export DOCKER_IMAGE_NAME := quassel-web
export DOCKER_NAME_SPACE := ${USER}
export DOCKER_VERSION    ?= latest
export BUILD_DATE        := $(shell date +%Y-%m-%d)
export BUILD_VERSION     := $(shell date +%y%m)
export BUILD_TYPE        ?= stable
export QUASSELWEB_VERSION ?= 2.2.8

.PHONY: build shell run exec start stop clean compose-file

default: build

build:
	@hooks/build

shell:
	@hooks/shell

run:
	@hooks/run

exec:
	@hooks/exec

start:
	@hooks/start

stop:
	@hooks/stop

clean:
	@hooks/clean

compose-file:
	@hooks/compose-file

#.PHONY: build push shell run start stop rm release
#
#
#build:
#	docker build \
#		--rm \
#		--tag $(NS)/$(REPO):$(VERSION) .
#
#clean:
#	docker rmi \
#		--force \
#		$(NS)/$(REPO):$(VERSION)
#	sudo rm -rf ${DATA_DIR}
#
#history:
#	docker history \
#		$(NS)/$(REPO):$(VERSION)
#
#push:
#	docker push \
#		$(NS)/$(REPO):$(VERSION)
#
#shell:
#	docker run \
#		--rm \
#		--name $(NAME)-$(INSTANCE) \
#		--interactive \
#		--tty \
#		$(PORTS) \
#		$(VOLUMES) \
#		$(ENV) \
#		$(NS)/$(REPO):$(VERSION) \
#		/bin/sh
#
#run:
#	docker run \
#		--rm \
#		--name $(NAME)-$(INSTANCE) \
#		$(PORTS) \
#		$(VOLUMES) \
#		$(ENV) \
#		$(NS)/$(REPO):$(VERSION)
#
#exec:
#	docker exec \
#		--interactive \
#		--tty \
#		$(NAME)-$(INSTANCE) \
#		/bin/sh
#
#start:
#	docker run \
#		--detach \
#		--name $(NAME)-$(INSTANCE) \
#		$(PORTS) \
#		$(VOLUMES) \
#		$(ENV) \
#		$(NS)/$(REPO):$(VERSION)
#
#stop:
#	docker stop \
#		$(NAME)-$(INSTANCE)
#
#rm:
#	docker rm \
#		$(NAME)-$(INSTANCE)
#
#release: build
#	make push -e VERSION=$(VERSION)
#
#default: build
#
#
#
