#!/bin/bash
# © Copyright 2020-2020 UCAR
# This software is licensed under the terms of the Apache Licence Version 2.0 which can be obtained at
# http://www.apache.org/licenses/LICENSE-2.0.


#
# make_dockerfile.sh - Generate the dockerfile from base.py via HPCCM
#
# Useage:
# make_dockerfile.sh <name> <tag> <hpc>
#
# <name> - name of image to build in format <compiler>-<mpi>-<type>
#           where <type> is dev (development) or app (application)
#           Default: gnu-openmpi-dev
#
# <tag> - optional tag for docker image
#
# <hpc> - this selects amoung possible hpc configurations
#         accepted values include:
#         0 (default): No hpc options
#         1: base configuration - sufficient for, e.g., S4
#            - UCX with KNEM, XPMEM
#            - OFED: linux inbox
#            - PMI: slurm-pmi2
#            - PSM: None
#         2: with Mellanox OFED and PSM
#            - UCX with KNEM, XPMEM
#            - OFED: Mellanox
#            - PMI: slurm-pmi2
#            - PSM: Yes
#
#------------------------------------------------------------------------
function get_ans {
    ans=''
    while [[ $ans != y ]] && [[ $ans != n ]]; do
      echo $1
      read ans < /dev/stdin
      if [[ $ans != y ]] && [[ $ans != n ]]; then echo "You must enter y or n"; fi
    done
}

#------------------------------------------------------------------------
if [[ $# -lt 1 ]]; then
   echo "usage: make_dockerfile <name> [<tag>] [<HPC>]"
   exit 1
fi

CNAME=${1:-"gnu-openmpi-dev"}
TAG=${2:-"beta"}
HPC=${3:-"0"}

CompilerName=$(echo $CNAME| cut -d- -f1)
MPIName=$(echo $CNAME| cut -d- -f2)

echo $CompilerName

if [[ $CompilerName =~ "intel" ]]; then

    echo "Building intel container"
    docker image build -f Dockerfile.intel-oneapi-os-tools-ubuntu20 -t jcsda/intel-oneapi-os-tools:ubuntu20 .
    docker image build -f Dockerfile.intel-oneapi-hpckit-ubuntu20 -t jcsda/intel-oneapi-hpckit:ubuntu20 .
    docker image build --no-cache -f Dockerfile.intel-oneapi-dev -t jcsda/docker_base-intel-oneapi-dev:${TAG} .
    exit 0
fi

case ${HPC} in
    "0")
        hpccm --recipe base-dev.py --userarg compiler=${CompilerName} \
                                                     mpi=${MPIName} \
	                                              --format docker > Dockerfile.$CNAME
        ;;
    "1")
        hpccm --recipe base-dev.py --userarg compiler=${CompilerName} \
                                                     mpi=${MPIName} \
                                                     hpc="True" \
                                                      --format docker > Dockerfile.$CNAME
        ;;
    "2")
        hpccm --recipe base-dev.py --userarg compiler=${CompilerName} \
                                                     mpi=${MPIName} \
                                                     hpc="True" \
                                                     mellanox="True" \
                                                     psm="True" \
                                                     --format docker > Dockerfile.$CNAME
        ;;
    *)
        echo "ERROR: unsupported HPC option"
	exit 1
        ;;
esac

echo "Generated with hpccm version: " > generated.version
hpccm --version >> generated.version

docker image build --no-cache -f Dockerfile.$CNAME -t jcsda/docker_base-$CNAME:${TAG} .

get_ans "Push to Docker Hub?"

if [[ $ans == y ]] ; then
    docker push jcsda/docker_base-$CNAME:${TAG}
fi
