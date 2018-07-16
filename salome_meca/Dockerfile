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
    https://www.code-aster.org/FICHIERS/salome_meca-2018-LGPL-1.tgz && \
    tar xf salome_meca-2018-LGPL-1.tgz && \
    ./salome_meca-2018-LGPL-1.run && \
    rm salome_meca-2018-LGPL-1.*
    # rm -rf salome_meca/appli_V2018 salome_meca/V2018/modules && \
    # cd salome_meca/V2018/prerequisites && \
    # rm -rf Paraview-v541p2 Qt-591

# Add as_run into PATH
RUN echo "" >> .bashrc && \
    echo "source ~/salome_meca/V2018/salome_prerequisites.sh" >> .bashrc && \
    echo "cat ~/WELCOME" >> .bashrc && \
    echo "echo" >> .bashrc

# Add a welcome message and a script for testcases
COPY salome_meca/WELCOME /home/aster/WELCOME
COPY run_tests.sh /home/aster/run_tests.sh

USER root
