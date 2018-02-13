
============
docker_base
============
Docker base container for *JEDI*, this image include the basic tools, such as :

- gnu compiler (**Using gnu compiler version 7**)
- openmpi 
- git
- git-flow 
- git-lfs 
- cmake
- csh
- ksh 
- kdbg
- ddd
- etc..

How to build the docker_base image
----------------------------------
.. highlight:: bash
.. code:: bash

  > docker image build -t jcsda/docker_base .
  > docker push jcsda/docker_base


Check out the docker base imgae
-------------------------------
.. code:: bash

  > docker pull jcsda/docker_base

How to run kdbg
---------------
.. code:: bash

  > docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY jcsda/docker_base kdbg
