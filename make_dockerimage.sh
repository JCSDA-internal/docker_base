#!/bin/bash

#
# make_dockerfile.sh - Generate the dockerfile from base.py via HPCCM
#
# Useage:
# make_dockerfile.sh <name> <tag>
#
# <name> - name of image to build in format <compiler>-<mpi>-<type>
#           where <type> is dev (development) or app (application)
#           Default: gnu-openmpi-dev
#
# <tag> - optional tag for docker image
#
if [[ $# -lt 1 ]]; then
   echo "usage: make_dockerfile <name>"
   exit 1
fi

NAME=${1:-"gnu-openmpi-dev"}
TAG=${2:-"latest"}

hpccm --recipe base-$NAME.py --format docker > Dockerfile.$NAME
echo "Generated with hpccm version: " > generated.version
hpccm --version >> generated.version

docker image build --no-cache -f Dockerfile.$NAME -t jcsda/docker_base-$NAME:$TAG .

# might want to do this manually after testing
# docker push jcsda/docker_base-$NAME
