#!/bin/bash

if [[ $# -ne 2 ]]; then
   echo "usage: make_dockerfile <compiler> <mpi>"
   exit 1
fi

HPCCM=../hpc-container-maker/hpccm.py

$HPCCM --recipe base_$1_$2.py --format docker > Dockerfile.$1_$2
echo "Generated with hpccm version: " > generated.version
$HPCCM --version >> generated.version
