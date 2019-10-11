#!/bin/bash

if [[ $# -ne 1 ]]; then
   echo "usage: make_dockerfile <name>"
   exit 1
fi

HPCCM=../hpc-container-maker/hpccm.py

$HPCCM --recipe base-$1.py --format docker > Dockerfile.$1
echo "Generated with hpccm version: " > generated.version
$HPCCM --version >> generated.version

docker image build --no-cache -f Dockerfile.$name -t jcsda/docker_base-$name .
