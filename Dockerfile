FROM ubuntu:16.04
LABEL maintainer "Tianyi Li <tianyikillua@gmail.com>"

# Get Ubuntu updates and packages
USER root
RUN apt-get update
RUN apt-get install -y \
    sudo \
    gcc g++ gfortran \
    wget \
    python \
    python-dev \
    python-numpy \
    python-qt4 \
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
WORKDIR /home/aster

RUN wget --no-check-certificate \
    https://www.code-aster.org/FICHIERS/Salome-Meca-2017.0.2-LGPL-2.tgz
RUN tar xvf Salome-Meca-2017.0.2-LGPL-2.tgz
RUN ./Salome-Meca-2017.0.2-LGPL-2.run

RUN rm Salome-Meca-2017.0.2-LGPL-2.*
RUN echo "source salome_meca/V2017.0.2/salome_prerequisites.sh" >> .bash_profile
