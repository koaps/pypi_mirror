FROM python:slim-bullseye

RUN apt-get update \
 && apt-get install -y locales \
 && dpkg-reconfigure -f noninteractive locales \
 && locale-gen C.UTF-8 \
 && /usr/sbin/update-locale LANG=C.UTF-8 \
 && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && locale-gen \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        bc \
        bison \
        build-essential \
        curl \
        flex \
        git \
        html2text \
        imagemagick \
        jq \
        less \
        libxtst-dev libev-dev libxext-dev libxrender-dev libfreetype6-dev \
        libffi-dev libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 \
        libgmp-dev libisl-dev libmpfr-dev libmpc-dev libpq-dev libncurses5-dev \
        libncurses-dev libssl-dev \
        make \
        software-properties-common \
        unzip \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN pip3 install -U pip \
    && pip install python-pypi-mirror
