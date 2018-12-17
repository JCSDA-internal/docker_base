FROM ubuntu:16.04
LABEL maintainer "Xin Zhang <xin.l.zhang@noaa.gov>"

# install basic tools
RUN apt-get clean \
    && apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && apt-add-repository ppa:ubuntu-toolchain-r/test \
    && apt-add-repository ppa:george-edison55/cmake-3.x \
    && apt-get update \
    && buildDeps='build-essential libcurl4-openssl-dev libexpat1-dev openssh-server libncurses-dev libssl-dev libxml2-dev autoconf locales pkg-config git cmake tcsh csh ksh vim file curl wget texinfo flex bison gcc-7 gfortran-7 g++-7 emacs git-flow gdb kdbg ddd graphviz texlive-latex-recommended libarmadillo-dev swig bc tk tcl libx11-dev subversion lynx valgrind less nedit man-db' \
    && apt-get install -y --no-install-recommends $buildDeps \
    && apt-get purge -y gcc g++ \
    && apt-get purge -y gcc-5 g++-5 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 10 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 10 \
    && update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-7 10 \
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-7 10 \
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
    && locale-gen en_US.UTF-8 \
    && git clone https://github.com/doxygen/doxygen.git \
    && cd doxygen \
    && mkdir build \
    && cd build \
    && cmake -G "Unix Makefiles" .. \
    && make \
    && make install \
    && cd /usr/local/src \
    && rm -rf doxygen \
    && apt-get remove -y libhdf5-dev libjpeg8-dev libsz2 libhdf5-cpp-11 libjpeg-dev libhdf5-10 libblas-common libblas3 hdf5-helpers libjpeg-turbo8-dev \
    && apt-get update \
    && buildDeps='python-pip python-dev python-yaml python-numpy python-scipy' \
    && apt-get install -y --no-install-recommends $buildDeps \
    && buildDeps='python3-pip python3-dev python3-yaml python3-numpy python3-scipy' \
    && apt-get install -y --no-install-recommends $buildDeps
    
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV PATH=.:/usr/loca/bin:$PATH

COPY tkdiff /usr/bin/.

CMD ["/bin/bash" , "-l"]
