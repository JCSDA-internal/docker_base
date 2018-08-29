FROM ubuntu:16.04
LABEL maintainer "Xin Zhang <xin.l.zhang@noaa.gov>"

# install basic tools
RUN apt-get clean \
    && apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && apt-add-repository ppa:ubuntu-toolchain-r/test \
    && apt-add-repository ppa:george-edison55/cmake-3.x \
    && apt-get update \
    && buildDeps='python-pip build-essential libcurl4-openssl-dev libexpat1-dev openssh-server libncurses-dev libssl-dev libxml2-dev autoconf locales pkg-config git cmake tcsh csh ksh vim file curl wget texinfo flex bison gcc-7 gfortran-7 g++-7 emacs git-flow gdb kdbg ddd python-dev graphviz texlive-latex-recommended libarmadillo-dev swig bc tk tcl libx11-dev subversion lynx valgrind less nedit man-db' \
    && apt-get install -y --no-install-recommends $buildDeps \
    && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
    && apt-get install git-lfs \
    && git lfs install \
    && rm -rf /var/lib/apt/lists/* \
    && cd /usr/local/src \
    && wget --no-check-certificate https://www.open-mpi.org/software/ompi/v3.1/downloads/openmpi-3.1.1.tar.gz \
    && tar xf openmpi-3.1.1.tar.gz \
    && rm openmpi-3.1.1.tar.gz \
    && cd openmpi-3.1.1 \
    && gcc --version \
    && gfortran --version \
    && opal_check_cma_happy=0 ./configure --enable-mpi-cxx  \
    && make -j `nproc` all && make install \
    && cd /usr/local/src \
    && rm -rf openmpi-3.1.1 \
    && wget ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-6.1.0/gcc-6.1.0.tar.gz \
    && tar -xzf gcc-6.1.0.tar.gz \
    && cd gcc-6.1.0 \
    && ./contrib/download_prerequisites \
    && cd .. \
    && mkdir gcc-6.1.0_build \
    && cd gcc-6.1.0_build \
    && ../gcc-6.1.0/configure --prefix=/usr --enable-languages=c,c++,fortran --disable-multilib \
    && make -j 2 \
    && make install \
    && rm -fr /usr/local/src/* \
    && cd /usr/local/src \
    && wget http://www.mpich.org/static/downloads/3.2/mpich-3.2.tar.gz \
    && tar -xzf mpich-3.2.tar.gz \
    && mkdir mpich-3.2_build \
    && cd mpich-3.2_build \
    && FC=gfortran ../mpich-3.2/configure --prefix=$INSTALL_DIR --enable-fortran=all --enable-cxx --enable-threads=multiple --enable-shared --enable-romio \
    && make -j 2 \
    && make install \
    && rm -rf /usr/local/src/* \
    && cd /usr/local/src \
    && locale-gen en_US.UTF-8 \
    && git clone https://github.com/doxygen/doxygen.git \
    && cd doxygen \
    && mkdir build \
    && cd build \
    && cmake -G "Unix Makefiles" .. \
    && make \
    && make install \
    && cd /usr/local/src \
    && rm -rf doxygen
    
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV PATH=.:/usr/loca/bin:$PATH

COPY tkdiff /usr/bin/.

CMD ["/bin/bash" , "-l"]
