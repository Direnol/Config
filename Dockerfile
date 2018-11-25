FROM ubuntu:bionic
LABEL author="Roman Mingazeev"

ENV \
    DEBIAN_FRONTEND=noninteractive \
    TERM=xterm \
    USER=debuser

RUN \
    apt update && apt install -y devscripts dh-make bash-completion \
    make git debhelper sudo dialog locales mc

RUN \
    adduser --disabled-password --gecos '' ${USER} && \
    mkdir -p /etc/sudoers.d/ &&\
    echo "${USER} ALL=NOPASSWD: ALL" > /etc/sudoers.d/${USER} &&\
    adduser ${USER} sudo && \
    locale-gen en_US.UTF-8 ru_RU.UTF-8 &&\
    update-locale LANG=ru_RU.UTF-8 && \
    update-locale LC_ALL=ru_RU.UTF-8


USER ${USER}
WORKDIR /home/${USER}/project

