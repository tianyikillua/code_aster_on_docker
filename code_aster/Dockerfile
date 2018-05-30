FROM quay.io/tianyikillua/base:latest
LABEL maintainer "Tianyi Li <tianyikillua@gmail.com>"

# Variables
ENV ASTER_SRC="https://www.code-aster.org/FICHIERS/aster-full-src-13.4.0-3.noarch.tar.gz"

ENV METIS_VER=5.1.0
ENV PETSC_VER=3.7.7
ENV PARMETIS_VER=4.0.3
ENV SCOTCH_VER=6.0.4
ENV MUMPS_VER=5.1.1

ENV PETSC_SRC="https://bitbucket.org/petsc/petsc/get/v${PETSC_VER}.tar.gz"
ENV PARMETIS_SRC="http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-${PARMETIS_VER}.tar.gz"
ENV SCOTCH_SRC="aster/SRC/scotch-${SCOTCH_VER}-aster5.tar.gz"
ENV MUMPS_SRC="aster/SRC/mumps-${MUMPS_VER}-aster2.tar.gz"

ENV ASTER_ROOT=/home/aster/aster
ENV PUBLIC=$ASTER_ROOT/public

# Get Ubuntu updates and basic packages
USER root
RUN apt-get update && \
    apt-get upgrade -y --with-new-pkgs -o Dpkg::Options::="--force-confold"
RUN apt-get install -y \
    make cmake \
    zlib1g-dev \
    tk bison flex \
    libopenblas-dev \
    libboost-python-dev \
    vim \
    libmpich-dev
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
USER aster
WORKDIR /tmp

# Download and install the latest stable version
RUN wget --no-check-certificate --quiet ${ASTER_SRC} -O aster.tar.gz
RUN mkdir aster && tar xf aster.tar.gz -C aster --strip-components 1 && \
    cd aster && \
    python setup.py install --prefix ${ASTER_ROOT} --noprompt

# Build ptscotch
RUN mkdir ptscotch && tar xf ${SCOTCH_SRC} -C ptscotch --strip-components 1 && \
    cd ptscotch && \
    make ptscotch ptesmumps CCD=mpicc && \
    make install prefix=${PUBLIC}/ptscotch-${SCOTCH_VER}

# Build parmetis
RUN wget --no-check-certificate --quiet ${PARMETIS_SRC} -O parmetis.tar.gz
RUN mkdir parmetis && tar xf parmetis.tar.gz -C parmetis --strip-components 1 && \
    cd parmetis && \
    make config prefix=${PUBLIC}/parmetis-${PARMETIS_VER} && \
    make && \
    make install

# Build parallel mumps
RUN mkdir mumps && tar xf ${MUMPS_SRC} -C mumps --strip-components 1 && \
    cd mumps && \
    export INCLUDES="${PUBLIC}/metis-${METIS_VER}/include \
                     ${PUBLIC}/parmetis-${PARMETIS_VER}/include \
                     ${PUBLIC}/ptscotch-${SCOTCH_VER}/include" && \
    export LIBPATH="${PUBLIC}/metis-${METIS_VER}/lib \
                    ${PUBLIC}/parmetis-${PARMETIS_VER}/lib \
                    ${PUBLIC}/ptscotch-${SCOTCH_VER}/lib" && \
    ./waf configure --prefix=${PUBLIC}/mumps-${MUMPS_VER}_mpi --install-tests --enable-mpi && \
    ./waf build && \
    ./waf install

# Build parallel PETSc
RUN wget --no-check-certificate --quiet ${PETSC_SRC} -O petsc.tar.gz
RUN mkdir petsc && tar xf petsc.tar.gz -C petsc --strip-components 1 && \
    cd petsc && \
    ./configure --COPTFLAGS="-O2" \
                --CXXOPTFLAGS="-O2" \
                --FOPTFLAGS="-O2" \
                --with-debugging=0 --with-shared-libraries=1 \
                --prefix=/home/aster/aster/public/petsc-3.7.7 \
                --download-hypre=yes --download-ml=yes --download-mumps=yes --download-scalapack=yes && \
    make all && \
    make install

# Build parallel aster

# Cleanup and add as_run into PATH
WORKDIR /home/aster
# RUN rm -rf /tmp/*
RUN echo "" >> .bashrc
RUN echo "source ~/aster/etc/codeaster/profile.sh" >> .bashrc
RUN echo "cat ~/WELCOME" >> .bashrc
RUN echo "echo" >> .bashrc

# Add a welcome message and a script for testcases
COPY code_aster/WELCOME /home/aster/WELCOME
COPY run_tests.sh /home/aster/run_tests.sh

USER root

# TODO: install the latest sequential and parallel development version
# ENV MED_SRC="http://files.salome-platform.org/Salome/other/med-3.3.1.tar.gz"
# ENV MFRONT_SRC="https://sourceforge.net/projects/tfel/files/tfel-3.1.1.tar.bz2"
# ENV MUMPS_SRC="https://bitbucket.org/code_aster/mumps/get/5.1.2_aster4.tar.gz"
