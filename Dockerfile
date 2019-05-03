FROM ubuntu:16.04 AS stage0

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6B05F25D762E3157 && \
    apt-get update

# GNU compiler
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends software-properties-common && \
    apt-add-repository ppa:ubuntu-toolchain-r/test -y && \
    apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        gcc-7 \
        g++-7 \
        gfortran-7 && \
    rm -rf /var/lib/apt/lists/*
RUN update-alternatives --install /usr/bin/gcc gcc $(which gcc-7) 30 && \
    update-alternatives --install /usr/bin/g++ g++ $(which g++-7) 30 && \
    update-alternatives --install /usr/bin/gfortran gfortran $(which gfortran-7) 30 && \
    update-alternatives --install /usr/bin/gcov gcov $(which gcov-7) 30

# CMake version 3.13.0
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        wget && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/tmp && wget -q -nc --no-check-certificate -P /var/tmp https://cmake.org/files/v3.13/cmake-3.13.0-Linux-x86_64.sh && \
    /bin/sh /var/tmp/cmake-3.13.0-Linux-x86_64.sh --prefix=/usr/local --skip-license && \
    rm -rf /var/tmp/cmake-3.13.0-Linux-x86_64.sh

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        tcsh \
        csh \
        ksh \
        openssh-server \
        libncurses-dev \
        libssl-dev \
        libx11-dev \
        less \
        man-db \
        tk \
        tcl \
        swig \
        bc \
        file \
        flex \
        bison \
        libexpat1-dev \
        libxml2-dev \
        unzip \
        wish \
        curl \
        wget \
        libcurl4-openssl-dev && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        emacs \
        vim \
        nedit \
        graphviz \
        doxygen \
        texlive-latex-recommended \
        texinfo \
        lynx \
        git \
        git-flow && \
    rm -rf /var/lib/apt/lists/*

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get update && \
    apt-get install -y --no-install-recommends git-lfs

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        autoconf \
        pkg-config \
        ddd \
        gdb \
        kdbg \
        valgrind && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        python-pip \
        python-dev \
        python-yaml \
        python-numpy \
        python-scipy \
        python3-pip \
        python3-dev \
        python3-yaml \
        python3-numpy \
        python3-scipy && \
    rm -rf /var/lib/apt/lists/*

# Mellanox OFED version 4.5-1.0.1.0
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libnl-3-200 \
        libnl-route-3-200 \
        libnuma1 \
        wget && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/tmp && wget -q -nc --no-check-certificate -P /var/tmp http://content.mellanox.com/ofed/MLNX_OFED-4.5-1.0.1.0/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu16.04-x86_64.tgz && \
    mkdir -p /var/tmp && tar -x -f /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu16.04-x86_64.tgz -C /var/tmp -z && \
    dpkg --install /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu16.04-x86_64/DEBS/libibverbs1_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu16.04-x86_64/DEBS/libibverbs-dev_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu16.04-x86_64/DEBS/ibverbs-utils_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu16.04-x86_64/DEBS/libibmad_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu16.04-x86_64/DEBS/libibmad-devel_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu16.04-x86_64/DEBS/libibumad_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu16.04-x86_64/DEBS/libibumad-devel_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu16.04-x86_64/DEBS/libmlx4-1_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu16.04-x86_64/DEBS/libmlx4-dev_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu16.04-x86_64/DEBS/libmlx5-1_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu16.04-x86_64/DEBS/libmlx5-dev_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu16.04-x86_64/DEBS/librdmacm-dev_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu16.04-x86_64/DEBS/librdmacm1_*_amd64.deb && \
    rm -rf /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu16.04-x86_64.tgz /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu16.04-x86_64

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libpsm-infinipath1 \
        libpsm-infinipath1-dev && \
    rm -rf /var/lib/apt/lists/*

# OpenMPI version 3.1.2
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        bzip2 \
        file \
        hwloc \
        libnuma-dev \
        make \
        openssh-client \
        perl \
        tar \
        wget && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/tmp && wget -q -nc --no-check-certificate -P /var/tmp https://www.open-mpi.org/software/ompi/v3.1/downloads/openmpi-3.1.2.tar.bz2 && \
    mkdir -p /var/tmp && tar -x -f /var/tmp/openmpi-3.1.2.tar.bz2 -C /var/tmp -j && \
    cd /var/tmp/openmpi-3.1.2 &&   ./configure --prefix=/usr/local --enable-mpi-cxx --with-psm --without-cuda --with-verbs && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    rm -rf /var/tmp/openmpi-3.1.2.tar.bz2 /var/tmp/openmpi-3.1.2
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH \
    PATH=/usr/local/bin:$PATH

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata locales && \
    ln -fs /usr/share/zoneinfo/America/Denver /etc/localtime && \
    locale-gen --purge en_US.UTF-8 && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale "LANG=en_US.UTF-8" && \
    update-locale "LANGUAGE=en_US:en"


