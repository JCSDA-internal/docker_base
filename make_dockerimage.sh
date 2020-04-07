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
   echo "usage: make_dockerfile <name>"
   exit 1
fi

CNAME=${1:-"gnu-openmpi-dev"}
TAG=${2:-"latest"}
HPC=${3:-"0"}

CompilerName=$(echo $CNAME| cut -d- -f1)
MPIName=$(echo $CNAME| cut -d- -f2)

case ${HPC} in
    "0")
        hpccm --recipe base-dev.py --userarg compiler=${CompilerName} \
                                                     mpi=${MPIName} \
	                                              --format docker > Dockerfile.$CNAME
        ;;
    "0")
        hpccm --recipe base-dev.py --userarg compiler=${CompilerName} \
                                                     mpi=${MPIName} \
                                                     hpc="True" \
                                                      --format docker > Dockerfile.$CNAME
        ;;
    "0")
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

if [[ ${TAG} == 'latest' ]]; then

    docker image build --no-cache -f Dockerfile.$CNAME -t jcsda/docker_base-$CNAME:beta .

    #------------------------------------------------------------------------
    get_ans "Push to Docker Hub?"

    if [[ $ans == y ]] ; then

        # save previous image in case something goes wrong
        docker pull jcsda/docker_base-$CNAME:latest
        docker tag jcsda/docker_base-$CNAME:latest jcsda/docker-$CNAME:revert
        docker push jcsda/docker_base-$CNAME:revert
        docker rmi jcsda/docker_base-$CNAME:latest

        # push new image and re-tag it with latest
        docker tag jcsda/docker_base-$CNAME:beta jcsda/docker-$CNAME:latest
        docker rmi jcsda/docker_base-$CNAME:beta
        docker push jcsda/docker_base-$CNAME:latest

    fi
    #------------------------------------------------------------------------

else

    docker image build --no-cache -f Dockerfile.$CNAME -t jcsda/docker_base-$CNAME:${TAG} .

    get_ans "Push to Docker Hub?"

    if [[ $ans == y ]] ; then
        docker push jcsda/docker_base-$CNAME:${TAG}
    fi

fi
