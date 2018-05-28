FROM ubuntu:16.04
LABEL maintainer "Tianyi Li <tianyikillua@gmail.com>"

# Variables
ENV ASTER_ROOT="/home/aster/aster"
ENV ASTER_SRC="https://www.code-aster.org/FICHIERS/aster-full-src-13.4.0-3.noarch.tar.gz"
ENV MED_SRC="http://files.salome-platform.org/Salome/other/med-3.3.1.tar.gz"
ENV MFRONT_SRC="https://sourceforge.net/projects/tfel/files/tfel-3.1.1.tar.bz2"
ENV MUMPS_SRC="https://bitbucket.org/code_aster/mumps/get/5.1.2_aster4.tar.gz"

# Get Ubuntu updates and basic packages
USER root
RUN apt-get update
RUN apt-get install -y \
    sudo \
    make cmake \
    gcc g++ gfortran \
    zlib1g-dev \
    wget \
    python \
    python-dev \
    python-numpy \
    python-qt4 \
    tk bison flex \
    libopenblas-dev \
    libboost-python-dev \
    libxft2 \
    libxss1

# Set locale environment
ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8

# Add a new user
RUN adduser --disabled-password --gecos "" aster
RUN adduser aster sudo
RUN echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER aster

# Download and install the latest production version
RUN mkdir /home/aster/src
WORKDIR /home/aster/src
RUN wget --no-check-certificate --quiet ${ASTER_SRC} -O aster-stable.tar.gz
RUN tar xf aster-stable.tar.gz && cd aster-stable
RUN python setup.py install --prefix ${ASTER_ROOT}

# Download the newest MEDfile library
# RUN wget --no-check-certificate --quiet ${MED_SRC} -O med.tar.gz
# RUN wget --no-check-certificate --quiet ${MFRONT_SRC} -O mfront.tar.bz2
# RUN wget --no-check-certificate --quiet ${MUMPS_SRC} -O mumps.tar.gz
