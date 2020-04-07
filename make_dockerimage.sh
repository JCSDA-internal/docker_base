#!/bin/bash

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
if [[ $# -lt 1 ]]; then
   echo "usage: make_dockerfile <name>"
   exit 1
fi

NAME=${1:-"gnu-openmpi-dev"}
TAG=${2:-"latest"}
HPC=${3:-"0"}

case ${HPC} in
    "0")
        hpccm --recipe base-$NAME.py --format docker > Dockerfile.$NAME
        ;;
    "0")
        hpccm --recipe base-$NAME.py --userarg hpc="True" --format docker > Dockerfile.$NAME
        ;;
    "0")
        hpccm --recipe base-$NAME.py --userarg hpc="True" mellanox="True" psm="True" --format docker > Dockerfile.$NAME
        ;;
    *)
        echo "ERROR: unsupported HPC option"
	exit 1
        ;;
esac

echo "Generated with hpccm version: " > generated.version
hpccm --version >> generated.version

docker image build --no-cache -f Dockerfile.$NAME -t jcsda/docker_base-$NAME:$TAG .

# might want to do this manually after testing
# docker push jcsda/docker_base-$NAME
