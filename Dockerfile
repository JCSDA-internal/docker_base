FROM ubuntu:18.04 AS stage0

# GNU compiler
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        gcc-7 \
        g++-7 \
        gfortran-7 && \
    rm -rf /var/lib/apt/lists/*
RUN update-alternatives --install /usr/bin/gcc gcc $(which gcc-7) 30 && \
    update-alternatives --install /usr/bin/g++ g++ $(which g++-7) 30 && \
    update-alternatives --install /usr/bin/gfortran gfortran $(which gfortran-7) 30 && \
    update-alternatives --install /usr/bin/gcov gcov $(which gcov-7) 30

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
        locales \
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
        cmake \
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
RUN mkdir -p /var/tmp && wget -q -nc --no-check-certificate -P /var/tmp http://content.mellanox.com/ofed/MLNX_OFED-4.5-1.0.1.0/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64.tgz && \
    mkdir -p /var/tmp && tar -x -f /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64.tgz -C /var/tmp -z && \
    dpkg --install /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64/DEBS/libibverbs1_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64/DEBS/libibverbs-dev_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64/DEBS/ibverbs-utils_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64/DEBS/libibmad_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64/DEBS/libibmad-devel_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64/DEBS/libibumad_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64/DEBS/libibumad-devel_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64/DEBS/libmlx4-1_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64/DEBS/libmlx4-dev_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64/DEBS/libmlx5-1_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64/DEBS/libmlx5-dev_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64/DEBS/librdmacm-dev_*_amd64.deb /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64/DEBS/librdmacm1_*_amd64.deb && \
    rm -rf /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64.tgz /var/tmp/MLNX_OFED_LINUX-4.5-1.0.1.0-ubuntu18.04-x86_64

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
    cd /var/tmp/openmpi-3.1.2 &&   ./configure --prefix=/usr/local/openmpi --enable-mpi-cxx --with-psm --without-cuda --with-verbs && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    rm -rf /var/tmp/openmpi-3.1.2.tar.bz2 /var/tmp/openmpi-3.1.2
ENV LD_LIBRARY_PATH=/usr/local/openmpi/lib:$LD_LIBRARY_PATH \
    PATH=/usr/local/openmpi/bin:$PATH


