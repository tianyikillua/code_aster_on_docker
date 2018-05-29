FROM quay.io/tianyikillua/base:latest
LABEL maintainer "Tianyi Li <tianyikillua@gmail.com>"

# Get Ubuntu updates
USER root
RUN apt-get update && \
    apt-get upgrade -y -o --with-new-pkgs Dpkg::Options::="--force-confold"

# Download and install the latest salome_meca
USER aster
WORKDIR /home/aster
RUN wget --no-check-certificate --quiet \
    https://www.code-aster.org/FICHIERS/Salome-Meca-2017.0.2-LGPL-2.tgz
RUN tar xf Salome-Meca-2017.0.2-LGPL-2.tgz
RUN ./Salome-Meca-2017.0.2-LGPL-2.run

# Cleanup and add as_run into PATH
RUN rm Salome-Meca-2017.0.2-LGPL-2.*
RUN echo "" >> .bashrc
RUN echo "source ~/salome_meca/V2017.0.2/salome_prerequisites.sh" >> .bashrc
RUN echo "cat ~/WELCOME" >> .bashrc
RUN echo "echo" >> .bashrc

# Add something (useful or not)
COPY salome_meca/WELCOME /home/aster/WELCOME
COPY run_tests.sh /home/aster/run_tests.sh

USER root
