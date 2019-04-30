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


