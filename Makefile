.PHONY: pre-build build clean

NAME=$(shell cat ./package-name)
VSN=$(shell cat ./package-vsn)

clean:
	@rm -rf ${NAME} *.deb *.build* *.changes

pre-build: clean
	@mkdir -p ${NAME}
	@cp -r ./debian ${NAME}

build: pre-build
	cd ${NAME} && \
	debuild -i -us -uc -b
