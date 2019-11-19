#!/bin/bash

#
# make_dockerfile.sh - Generate the dockerfile from base.py via HPCCM
#
# Useage:
# make_dockerfile.sh <name> <hpccm>
#
# <name> - name of image to build in format <compiler>-<mpi>-<type>
#           where <type> is dev (development) or app (application)
#           Default: gnu-openmpi-dev
#
# <hpccm> - location of hpccm.py or hpccm executable
#           Default: ../hpc-container-maker/hpccm.py
#
if [[ $# -lt 1 ]]; then
   echo "usage: make_dockerfile <name> <hpccm>"
   exit 1
fi

NAME=${1:-"gnu-openmpi-dev"}
HPCCM=${2:-../hpc-container-maker/hpccm.py}

$HPCCM --recipe base-$NAME.py --format docker > Dockerfile.$NAME
echo "Generated with hpccm version: " > generated.version
$HPCCM --version >> generated.version

docker image build --no-cache -f Dockerfile.$NAME -t jcsda/docker_base-$NAME .

# might want to do this manually after testing
# docker push jcsda/docker_base-$NAME
