============
docker_base
============
Docker base container for *JEDI*.

The main responsibility of this repository is to set up a Docker image file
that includes these basic components:

- An ubuntu 20.04 operating system

- A selection of useful packages, most installed with `apt`

  - wget, curl
  - git, git-flow, git-lfs
  - cmake, autoconfig
  - vim, emacs, nedit
  - doxygen, latex
  - python3 (numpy, scipy, yaml)
  - valgrind, clang-tidy, etc
  - etc..

- optional enhancements for HPC environments, including

  - Infiniband OFED drivers: Mellanox or generic linux inbox
  - `UCX <https://www.openucx.org/>`_ and components (knem, xpmem)
  - hpcx
  - Intel's PSM (Performace Scaled Messaging) library
  - Slurm PMI2 library (or alternative)

For further information on any of these components, see NVIDIA's `HPC Container Maker documentation <https://github.com/NVIDIA/hpc-container-maker/blob/master/docs/building_blocks.md>`_.

For the public containers, namely gnu-openmpi and clang-mpich, the `docker_base` container also includes:

- A Compiler suite (C++, C, Fortran)
- An MPI library (currently openmpi but other options such as mpich will be developed in the future)

However, the compiler suite and MPI library are not included in the intel `docker_base` containers because we do not have legal permission to distribute this content on Docker Hub.  So, these are added in a later stage of the build process. Consult the `containers repository <https://github.com/JCSDA-internal/oops/blob/develop/docs/Intel.md>`_ for further information.


How to build the docker_base image
----------------------------------

This repository makes use of `NVIDIA's HPC Container Maker <https://github.com/NVIDIA/hpc-container-maker>`_ so, if you want to make changes, **do not edit the Dockerfiles directly**.

Instead, edit the `base-dev.py` python file.  This is what generates the Dockerfiles automatically.

So, if you want to build `docker_base` containers, the first step is to install the HPC container maker, ``hpccm``.  This is a python package that you can install with ``pip`` or ``conda``

.. code-block:: bash

  sudo pip install hpccm

.. code-block:: bash

  conda install -c conda-forge hpccm

Then just run the ``make_dockerimage.sh`` script to build a container (respond to questions if prompted):

.. code-block:: bash

   ./make_dockerimage.sh gnu-openmpi-dev beta 0

The script takes three arguments.  The first is the name of the container.  This should follow the naming convention of ``<compiler>-<mpi>-dev``.  The last component of this name indicates the type of container, but since application and tutorial containers are generally built from development containers, ``dev`` is generally appropriate here.

Currently supported names on JCSDA Docker Hub include:
- ``gnu-openmpi-dev``
- ``clang-mpich-dev``
- ``intel-impi-dev``

The second argument to ``make_dockerimage.sh`` is the tag for the docker container.  If omitted, the default value is ``beta``.  As noted below, the typical workflow is to create a ``beta`` version of the container first for testing.  Then, when tests pass, you can push it to docker hub.

The third argument to ``make_dockerimage.sh`` is the HPC flag and it controls the optional enhancements for HPC environments referred to above.   If you only plan to use the container for single-node development and testing, then these optional HPC components are not needed so you can set this value to zero.

The default value for this HPC flag is 1, which means that generic infiniband OFED drivers are included in the container, along with other HPC-ready components such as UCX and slurm-pmi2.  Benchmarking indicate that this does not significantly influence the single-node performance or significantly increase the size of the container so these components are included by default, in case users do want to run applications across nodes on HPC systems.

Setting the HPC flag to 2 installs the Mellanox OFED infiniband drivers instead of the generic OFED drivers.  The generic drivers are expected to be more portable but the mellanox version can give better performance on systems that have mellanox hardware.

Currently, setting the HPC flag to 2 also installs Intel's PSM library, which can help portability for some systems.

*Note:* if the HPC flag is set to 2, the ``make_dockerimage.sh`` script will append ``-mlnx`` to the container name entered as the first argument on the command line.

Testing and deploying the container
-----------------------------------

After creating the docker base container with ``make_dockerimage.sh``, it is generally a good idea to run it and make sure everthing looks correct (compilers and packages are there and accessible).

.. code-block:: bash

    docker run --rm -it gnu-openmpi-dev:beta

When it looks good, you can push the container to Docker Hub with

.. code-block:: bash

  ./push_beta_to_latest.sh gnu-openmpi-dev beta

The first argument is the name of the container (required) and the second argument is the tag (optional - defaults to ``beta``).

If the tag is ``beta``, then the script will first make a copy of the current ``latest`` container on Docker Hub and re-tag is as ``revert``.  Then it will retag the ``beta`` container as ``latest`` and push it to Docker Hub.

If the tag is something other than ``beta``, then the ``push_beta_to_latest.sh`` script will just push the image to Docker Hub, without making a backup.

Check out the docker base image
---------------------------------

To pull a JCSDA container from Docker Hub, enter for example (substitute other names and tags as appropriate):

.. code:: bash

  docker pull jcsda/docker_base-gnu-openmpi-dev:latest
