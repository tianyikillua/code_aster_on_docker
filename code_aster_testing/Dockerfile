FROM quay.io/tianyikillua/base:latest
LABEL maintainer "Tianyi Li <tianyikillua@gmail.com>"

# Variables
ENV ASTER_FULL_SRC="https://www.code-aster.org/FICHIERS/aster-full-src-14.2.0-1.noarch.tar.gz"
ENV ASTER_ROOT=/home/aster/aster
ENV PUBLIC=$ASTER_ROOT/public

# Get Ubuntu updates and basic packages
USER root
RUN apt-get update && \
    apt-get upgrade -y --with-new-pkgs -o Dpkg::Options::="--force-confold" && \
    apt-get install -y \
    patch \
    make cmake \
    zlib1g-dev \
    tk bison flex \
    libglu1-mesa libxcursor-dev \
    libmpich-dev \
    libopenblas-dev \
    libboost-python-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER aster
WORKDIR /tmp

# Download and install the latest testing version
RUN wget --no-check-certificate --quiet ${ASTER_FULL_SRC} -O aster_full.tar.gz && \
    mkdir aster_full && tar xf aster_full.tar.gz -C aster_full --strip-components 1 && \
    cd aster_full && \
    python setup.py install --prefix ${ASTER_ROOT} --noprompt && \
    rm -rf /tmp/*

# Add a welcome message and a script for testcases
WORKDIR /home/aster
COPY code_aster_testing/WELCOME /home/aster/WELCOME
COPY run_tests.sh /home/aster/run_tests.sh

RUN echo "" >> .bashrc && \
    echo "source /home/aster/aster/etc/codeaster/profile.sh" >> .bashrc && \
    echo "cat ~/WELCOME" >> .bashrc && \
    echo "echo" >> .bashrc

USER root
