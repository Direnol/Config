.PHONY: pre-build build clean tc toolchain raw-build cli install \
		remove purge reconfigure

NAME=$(shell cat ./package-name)
VSN=$(shell cat ./package-vsn)
DATE=$(shell date -R)
DEB=${NAME}_${VSN}_all.deb
DESC=$(shell git log -1 --pretty=\%B)
DOCKER=$(shell which docker)
MAKE=$(shell which make)
TOOLCHAIN=toolchain-${NAME}:${VSN}
HOST=$(shell hostname)
DUSER=debuser
PARAM=--volume "${PWD}":/home/${DUSER}/project \
		--volume "${HOME}"/.ssh:/home/${DUSER}/.ssh \
		--tmpfs /tmp:exec,size=2G \
		--env UID=$(shell id -u) \
		--env GID=$(shell id -g) \
		--hostname ${HOST} \
		--privileged \
		--cap-add=ALL \
		--rm

all: tc build
rebuild: clean build
re-install: rebuild install

tc: toolchain
toolchain:
	@${DOCKER} build -t ${TOOLCHAIN} --rm .

build:
	@${DOCKER} run \
		${PARAM} \
		${TOOLCHAIN} \
		${MAKE} raw-build

cli:
	@${DOCKER} run \
		${PARAM} \
		-it ${TOOLCHAIN}

clean:
	@rm -rf ${NAME} *.deb *.build* *.changes

pre-build: clean
	@mkdir -p ${NAME}
	@cp -r ./debian ${NAME}
	@sed -i \
		-e "s/%%DATE%%/${DATE}/g" \
		-e "s/%%VSN%%/${VSN}/g"  \
		-e "s/%%DESC%%/${DESC}/g" \
		${NAME}/debian/changelog

%.deb: build

install: ${DEB}
	@sudo dpkg --install $<

remove: ${DEB}
	@sudo dpkg --remove $<

purge: ${DEB}
	@sudo dpkg --purge $<

reconfigure: ${DEB}
	@sudo dpkg-reconfigure $<

# Raw section
#######################################

raw-build: pre-build
	cd ${NAME} && \
	debuild -i -us -uc -b --lintian-opts --profile debian
