"""Prototype JEDI docker_base container

Usage:
$ ../hpc-container-maker/hpccm.py --recipe base.py --format docker > Dockerfile
"""

# Base image
Stage0.baseimage('ubuntu:18.04')

# Install GNU compilers 
Stage0 += gnu(version='7')

# useful system tools 
# libexpat is required by udunits
Stage0 += apt_get(ospackages=['build-essential','tcsh','csh','ksh',	    
                              'openssh-server','libncurses-dev','libssl-dev',
                              'libx11-dev','less','man-db','tk','tcl','swig',
                              'bc','file','flex','bison','libexpat1-dev',
                              'libxml2-dev','unzip','wish','curl','wget',
                              'libcurl4-openssl-dev'])

# editors, document tools, git, and git-flow                   
Stage0 += apt_get(ospackages=['emacs','vim','nedit','graphviz','doxygen',
                              'texlive-latex-recommended','texinfo',
                              'lynx','git','git-flow'])
# git-lfs
Stage0 += shell(commands=
                ['curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash',
                 'apt-get update','apt-get install -y --no-install-recommends git-lfs'])
                  
# autoconfig, cmake, and debuggers                  
Stage0 += apt_get(ospackages=['autoconf','pkg-config','cmake','ddd','gdb','kdbg',
                              'valgrind'])
    
# python
Stage0 += apt_get(ospackages=['python-pip','python-dev','python-yaml',
	                      'python-numpy','python-scipy',
                              'python3-pip','python3-dev','python3-yaml',
                              'python3-numpy','python3-scipy'])

# Mellanox OFED
Stage0 += mlnx_ofed(version='4.5-1.0.1.0')

# PSM library
Stage0 += apt_get(ospackages=['libpsm-infinipath1','libpsm-infinipath1-dev'])

# OpenMPI
Stage0 += openmpi(prefix='/usr/local', version='3.1.2', cuda=False, infiniband=True, 
                  configure_opts=['--enable-mpi-cxx --with-psm'])

# locales time zone and language support
Stage0 += shell(commands=
    ['apt-get update',
     'DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata locales',
     'ln -fs /usr/share/zoneinfo/America/Denver /etc/localtime',
     'locale-gen --purge en_US.UTF-8',
     'dpkg-reconfigure --frontend noninteractive tzdata',
     'dpkg-reconfigure --frontend=noninteractive locales',
     'update-locale \"LANG=en_US.UTF-8\"',
     'update-locale \"LANGUAGE=en_US:en\"'])

