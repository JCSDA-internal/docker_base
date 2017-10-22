FROM ubuntu:16.04
LABEL maintainer "Xin Zhang <xin.l.zhang@noaa.gov>"

# install basic tools
RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && apt-add-repository ppa:ubuntu-toolchain-r/test \
    && apt-add-repository ppa:george-edison55/cmake-3.x \
    && apt-get update \
    && buildDeps='build-essential libcurl4-openssl-dev libexpat1-dev openssh-server autoconf git cmake csh ksh vim file curl wget texinfo flex bison gcc-6 gfortran-6 g++-6 ' \ 
    && apt-get install -y --no-install-recommends $buildDeps \
    && apt-get purge -y gcc g++ \
    && apt-get purge -y gcc-5 g++-5 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 10 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 10 \
    && update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-6 10 \
    && rm -rf /var/lib/apt/lists/* \
    && cd /usr/local/src \
    && wget --no-check-certificate https://www.open-mpi.org/software/ompi/v2.1/downloads/openmpi-2.1.0.tar.gz \
    && tar xf openmpi-2.1.0.tar.gz \
    && rm openmpi-2.1.0.tar.gz \
    && cd openmpi-2.1.0 \
    && gcc --version \
    && gfortran --version \
    && opal_check_cma_happy=0 ./configure --enable-mpi-cxx  \
    && make -j `nproc` all && make install \
    && cd /usr/local/src \
    && rm -rf openmpi-2.1.0
    
ENV LD_LIBRARY_PATH=/usr/local/lib

CMD ["/bin/bash" , "-l"]
