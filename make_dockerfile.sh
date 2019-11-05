#!/bin/bash
#
# make_dockerfile.sh - Generate the dockerfile from base.py via HPCCM
#
# Useage:
# make_dockerfile.sh <hpccm>
#
# <hpccm> - location of hpccm.py or hpccm executable
#           Default: ../hpc-container-maker/hpccm.py
#
HPCCM=${1:-../hpc-container-maker/hpccm.py}

$HPCCM --recipe base.py --format docker > Dockerfile
echo "Generated with hpccm version: " > generated.version
$HPCCM --version >> generated.version
