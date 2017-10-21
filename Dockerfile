FROM ubuntu:16.04
LABEL maintainer "Xin Zhang <xin.l.zhang@noaa.gov>"

ARG FC=gfortran
ARG CC=gcc
ARG CXX=g++

# install basic tools and openmpi
RUN buildDeps='git libcurl4-openssl-dev autoconf automake gcc g++ make gfortran libexpat1-dev wget vim file texinfo cmake csh ksh mlocate openssh-server net-tools libmpc-dev gcc-multilib zip ca-certificates libncurses-dev python-dev libssl-dev libxml2-dev flex bison pkg-config xserver-xorg-dev libxaw7-dev tk tcl libx11-dev' \ 
    && echo 'deb http://ppa.launchpad.net/george-edison55/cmake-3.x/ubuntu trusty main' | tee -a /etc/apt/sources.list.d/cmake.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && rm -rf /var/lib/apt/lists/* \
    && updatedb \
    && cd /usr/local/src/ \
    && wget --no-check-certificate http://www.netgull.com/gcc/releases/gcc-6.3.0/gcc-6.3.0.tar.gz \
    && tar xf gcc-6.3.0.tar.gz \
    && rm gcc-6.3.0.tar.gz \
    && cd gcc-6.3.0 \
    && ./configure --prefix=/usr \
    && make -j `nproc` \
    && make install \
    && cd /usr/local/src \
    && rm -rf gcc-6.3.0
    
ENV PATH=/usr/bin:/usr/local/bin:/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/lib
    
CMD ["/bin/bash" , "-l"]
