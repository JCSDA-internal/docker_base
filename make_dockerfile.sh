#!/bin/bash

HPCCM=../hpc-container-maker/hpccm.py

$HPCCM --recipe base.py --format docker > Dockerfile
echo "Generated with hpccm version: " > generated.version
$HPCCM --version >> generated.version
