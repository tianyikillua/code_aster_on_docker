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

# Download and install the latest salome_meca
RUN wget --no-check-certificate --quiet \
    https://www.code-aster.org/FICHIERS/Salome-Meca-2017.0.2-LGPL-2.tgz
RUN tar xf Salome-Meca-2017.0.2-LGPL-2.tgz
RUN ./Salome-Meca-2017.0.2-LGPL-2.run

# Cleanup and add as_run into PATH
RUN rm Salome-Meca-2017.0.2-LGPL-2.*
RUN echo "" >> .bashrc
RUN echo "source ~/salome_meca/V2017.0.2/salome_prerequisites.sh" >> .bashrc
RUN echo "cat ~/WELCOME" >> .bashrc

# Add something (useful or not)
COPY WELCOME ~/WELCOME
COPY run_tests.sh ~/run_tests.sh
