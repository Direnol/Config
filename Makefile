.PHONY: pre-build build clean

NAME=$(shell cat ./package-name)
VSN=$(shell cat ./package-vsn)
DATE=$(shell date -R)
DESC=$(shell git log -1 --pretty=\%B)

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

build: pre-build
	cd ${NAME} && \
	debuild -i -us -uc -b --lintian-opts --profile debian
