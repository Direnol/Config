.PHONY: pre-build build clean

NAME=$(shell cat ./package-name)
VSN=$(shell cat ./package-vsn)

clean:
	@rm -rf ${NAME}

pre-build: clean
	@mkdir -p ${NAME}
	@cp -r ./debian ${NAME}

build: pre-build
	cd ${NAME} && \
	debuild -us -uc
