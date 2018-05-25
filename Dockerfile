FROM ubuntu:16.04
LABEL maintainer "Tianyi Li <tianyikillua@gmail.com>"

# Get Ubuntu updates
USER root
RUN apt-get update && apt-get install -y sudo apt-utils bsdtar

# Install packages
RUN apt-get install -y \
    gcc g++ gfortran \
    wget \
    python \
    python-dev \
    python-numpy \
    libxft2 \
    libxss1

# Set locale environment
ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8

# Add a new user
RUN useradd -ms /bin/bash aster
RUN adduser aster sudo
USER aster
WORKDIR /home/aster

RUN /bin/bash -c "wget --no-check-certificate \
                  https://www.code-aster.org/FICHIERS/Salome-Meca-2017.0.2-LGPL-2.tgz && \
                  bsdtar xvf Salome-Meca-2017.0.2-LGPL-2.tgz && \
                  ./Salome-Meca-2017.0.2-LGPL-2.run"
