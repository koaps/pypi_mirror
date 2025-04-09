FROM python:slim-bookworm

ARG cmake_version=4.0.0
ARG python_release=3.13
ARG python_version=3.13.2

RUN apt-get update \
 && apt-get install -y locales \
 && dpkg-reconfigure -f noninteractive locales \
 && locale-gen C.UTF-8 \
 && /usr/sbin/update-locale LANG=C.UTF-8 \
 && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && locale-gen \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        bc \
        bison \
        build-essential \
        curl \
        dh-autoreconf \
        flex \
        git \
        html2text \
        imagemagick \
        jq \
        less \
        libxtst-dev libev-dev libxext-dev libxrender-dev libfreetype6-dev \
        libffi-dev libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 \
        libgmp-dev libisl-dev libmpfr-dev libmpc-dev libpq-dev libncurses5-dev \
        libncurses-dev libssl-dev libssh-dev \
	pkg-config \
        software-properties-common \
        unzip \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN wget https://github.com/Kitware/CMake/releases/download/v${cmake_version}/cmake-${cmake_version}.tar.gz \
    && tar zxvf cmake-${cmake_version}.tar.gz \
    && cd cmake-${cmake_version} \
    && ./bootstrap \
    && make \
    && make install \
    && cd ../; rm -rf cmake-${cmake_version}*

RUN wget https://www.python.org/ftp/python/${python_version}/Python-${python_version}.tgz \
    && gzip -d Python-${python_version}.tgz \
    && tar xvf Python-${python_version}.tar \
    && cd Python-${python_version} \
    && ./configure --enable-optimizations \
    && make -j `nproc` \
    && make altinstall \
    && cd ../; rm -rf Python-${python_version}* \
    && ln -sf /usr/local/bin/python${python_release} /usr/local/bin/python3 \
    && ln -sf /usr/local/bin/python${python_release} /usr/local/bin/python \
    && ln -sf /usr/local/bin/pip${python_release} /usr/local/bin/pip3 \
    && ln -sf /usr/local/bin/pip${python_release} /usr/local/bin/pip

RUN /usr/local/bin/pip3 install -U pip \
    && /usr/local/bin/pip3 install python-pypi-mirror \
    && /usr/local/bin/pip3 install --upgrade pip setuptools wheel

CMD ["sleep", "infinity"]
