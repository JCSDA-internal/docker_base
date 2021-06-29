# © Copyright 2020-2020 UCAR
# This software is licensed under the terms of the Apache Licence Version 2.0 which can be obtained at
# http://www.apache.org/licenses/LICENSE-2.0.
#

"""JEDI docker_base development container

Usage:
hpccm --recipe base-dev.py --userarg compiler="gnu" mpi="openmpi" hpc="True" psm="True" --format docker > Dockerfile
"""

# Base image
Stage0.baseimage('ubuntu:20.04')

# get optional user arguments
mycompiler = USERARG.get('compiler', 'gnu')
mympi = USERARG.get('mpi', 'openmpi')
hpcstring = USERARG.get('hpc', 'False')
mxofed = USERARG.get('mellanox', 'False')
psm = USERARG.get('psm', 'False')

if (hpcstring.lower() == "true"):
    hpc=True
else:
    hpc=False

# update apt keys
Stage0 += apt_get(ospackages=['build-essential','gnupg2','apt-utils'])
#Stage0 += shell(commands=['apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6B05F25D762E3157',
#                          'apt-get update'])

# useful system tools
# libexpat is required by udunits
Stage0 += apt_get(ospackages=['tcsh','csh','ksh', 'openssh-server','libncurses-dev',
                              'libssl-dev','libx11-dev','less','man-db','tk','tcl','swig',
                              'bc','file','flex','bison','libexpat1-dev',
                              'libxml2-dev','unzip','wish','curl','wget','time',
                              'libcurl4-openssl-dev','nano','screen','lsb-release',
                              'libgmp-dev','libmpfr-dev','libboost-thread-dev'])

# Install GNU compilers - note that clang needs gfortran
# Stage0 += gnu(extra_repository=True,version='9')
if (mycompiler.lower() != "intel"):
    Stage0 += gnu(version='9')

# Install clang compilers
if (mycompiler.lower() == "clang"):
    Stage0 += llvm(extra_repository=True, version='8')

# get an up-to-date version of CMake
Stage0 += cmake(eula=True,version="3.19.2")

# editors, document tools, git, and git-flow
Stage0 += apt_get(ospackages=['emacs','vim','nedit','graphviz','doxygen',
                              'texlive-latex-recommended','texinfo','lynx',
                              'git','git-flow','imagemagick','tex4ht'])
# git-lfs
Stage0 += shell(commands=
                ['curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash',
                 'apt-get update','DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git-lfs', 'git lfs install --skip-repo'])

# autoconfig and debuggers
Stage0 += apt_get(ospackages=['autoconf','pkg-config','ddd','gdb','valgrind','clang-tidy'])

# python3
Stage0 += apt_get(ospackages=['python3-pip','python3-dev','python3-yaml',
                              'python3-scipy'])
Stage0 += shell(commands=['ln -s /usr/bin/python3 /usr/bin/python'])

# Mellanox or inbox OFED
if (hpc):
    if (mxofed.lower() == "true"):
        Stage0 += mlnx_ofed(version='5.2-1.0.4.0')
        Stage0 += hpcx(version='2.8.0',mlnx_ofed='5.2-1.0.4.0',multi_thread=True)
    else:
        Stage0 += ofed()
        # omit this for now because hpccm isn't up to date with ubuntu 20.04
        # If you really want it, you can get it to work if you manually edit the Dockerfile and
        # replace x86_64 with aarch64 in the file name.  So, the correct filename would be
        # http://www.mellanox.com/downloads/hpc/hpc-x/v2.8/hpcx-v2.8.0-gcc-inbox-ubuntu20.04-aarch64.tbz
        #Stage0 += hpcx(version='2.8.0',inbox=True)
    infiniband=True

    # PSM library
    if (psm.lower() == "true"):
        Stage0 += apt_get(ospackages=['libpsm-infinipath1','libpsm-infinipath1-dev'])
        withpsm=True
    else:
        withpsm=False

    # UCX and components
    Stage0 += knem()
    Stage0 += xpmem()
    Stage0 += ucx(ofed=True,knem=True,xpmem=True,cuda=False)

    # PMI library
    # Warning: installing slurm-pmi2 before the compilers and jedi-stack means
    # that some options are not selected, such as support for hdf5, pmix, and netloc
    # If we're preformance tuning, we may want to re-install this at later stage
    Stage0 += slurm_pmi2(version='20.02.7',ospackages=['libgtk-3-0','libgtk-3-dev',
              'libglib2.0-0','libglib2.0-dev','liblua5.2-0','liblua5.2-dev',
              'libmunge2','libmunge-dev','libyaml-dev','libhwloc-dev','libjson-c-dev',
              'libfreeipmi-dev','default-libmysqlclient-dev','libpam0g-dev',
              'libfreeipmi-dev'])

    if (mympi.lower() == "mpich"):

        #mpich
        # have to do this manually since the builing block doesn't work
        if (mycompiler.lower() == "clang"):
            Stage0 += environment(variables={'FC':'gfortran','CC':'clang','CXX':'clang++',
                'CFLAGS':'-fPIC','CXXFLAGS':'-fPIC','FCFLAGS':'-fPIC'})
        else:
            Stage0 += environment(variables={'FC':'gfortran','CC':'gcc','CXX':'g++',
                'CFLAGS':'-fPIC','CXXFLAGS':'-fPIC','FCFLAGS':'-fPIC'})
        Stage0 += mpich(version='3.3.1', configure_opts=['--enable-cxx --enable-fortran'])

    elif (mympi.lower() == "openmpi"):
        # OpenMPI
        Stage0 += openmpi(prefix='/usr/local', version='4.0.3', cuda=False, infiniband=infiniband,
                          pmi="/usr/local/slurm-pmi2",ucx="/usr/local/ucx", with_psm=withpsm,
                          configure_opts=['--enable-mpi-cxx'])
else:

    if (mympi.lower() == "mpich"):

        #mpich
        Stage0 += environment(variables={'FC':'gfortran','CC':'clang','CXX':'clang++',
            'CFLAGS':'-fPIC','CXXFLAGS':'-fPIC','FCFLAGS':'-fPIC'})
        Stage0 += mpich(version='3.3.2', configure_opts=['--enable-cxx --enable-fortran'])

    elif (mympi.lower() == "openmpi"):
        # OpenMPI
        Stage0 += openmpi(prefix='/usr/local', version='4.0.3', cuda=False, infiniband=False,
                          configure_opts=['--enable-mpi-cxx'])

# lcov 1.15
Stage0 += shell(commands=
          ['cd /usr/local/src',
           'wget https://github.com/linux-test-project/lcov/archive/v1.15.tar.gz',
           'tar -xvf v1.15.tar.gz', 'cd lcov-1.15', 'make install'])
