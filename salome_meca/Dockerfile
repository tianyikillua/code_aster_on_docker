FROM quay.io/tianyikillua/base:latest
LABEL maintainer "Tianyi Li <tianyikillua@gmail.com>"

# Get Ubuntu updates
USER root
RUN apt-get update && \
    apt-get upgrade -y --with-new-pkgs -o Dpkg::Options::="--force-confold" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download and install the latest salome_meca
USER aster
WORKDIR /home/aster
RUN wget --no-check-certificate --quiet \
    https://www.code-aster.org/FICHIERS/Salome-Meca-2017.0.2-LGPL-2.tgz && \
    tar xf Salome-Meca-2017.0.2-LGPL-2.tgz && \
    ./Salome-Meca-2017.0.2-LGPL-2.run && \
    rm Salome-Meca-2017.0.2-LGPL-2.*

# Add as_run into PATH
RUN echo "" >> .bashrc && \
    echo "source ~/salome_meca/V2017.0.2/salome_prerequisites.sh" >> .bashrc && \
    echo "cat ~/WELCOME" >> .bashrc && \
    echo "echo" >> .bashrc

# Add a welcome message and a script for testcases
COPY salome_meca/WELCOME /home/aster/WELCOME
COPY run_tests.sh /home/aster/run_tests.sh

USER root
