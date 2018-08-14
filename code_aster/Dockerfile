FROM quay.io/tianyikillua/base:latest
LABEL maintainer "Tianyi Li <tianyikillua@gmail.com>"

# Variables
ENV HDF5_VER=1.8.14
ENV MED_VER=3.3.1
ENV METIS_VER=5.1.0
ENV PARMETIS_VER=4.0.3
ENV SCOTCH_VER=6.0.4
ENV MUMPS_VER=5.1.1
ENV MFRONT_VER=3.0.0
ENV PETSC_VER=3.7.7
ENV SCALAPACK_VER=2.0.2
ENV ASTER_VER=13.6

ENV SCOTCH_SRC="scotch-${SCOTCH_VER}-aster5.tar.gz"
ENV MUMPS_SRC="mumps-${MUMPS_VER}-aster2.tar.gz"
ENV ASTER_SRC="aster-${ASTER_VER}.0.tgz"
ENV SCALAPACK_SRC="http://www.netlib.org/scalapack/scalapack-${SCALAPACK_VER}.tgz"
ENV PARMETIS_SRC="http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-${PARMETIS_VER}.tar.gz"
ENV PETSC_SRC="https://bitbucket.org/petsc/petsc/get/v${PETSC_VER}.tar.gz"

ENV ASTER_FULL_SRC="https://www.code-aster.org/FICHIERS/aster-full-src-13.6.0-1.noarch.tar.gz"
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

# Download and install the latest stable version
RUN wget --no-check-certificate --quiet ${ASTER_FULL_SRC} -O aster_full.tar.gz && \
    mkdir aster_full && tar xf aster_full.tar.gz -C aster_full --strip-components 1 && \
    cd aster_full && \
    python setup.py install --prefix ${ASTER_ROOT} --noprompt && \
    mv SRC/${SCOTCH_SRC} SRC/${MUMPS_SRC} SRC/${ASTER_SRC} /tmp && \
    rm -rf /tmp/aster_full.tar.gz /tmp/aster_full

# Build ptscotch
COPY --chown=aster:aster code_aster/data/patch_ptscotch /tmp/patch_ptscotch
RUN mkdir ptscotch && tar xf ${SCOTCH_SRC} -C ptscotch --strip-components 1 && \
    patch -s -p0 < patch_ptscotch && \
    cd ptscotch/src && \
    make scotch esmumps ptscotch ptesmumps CCD=mpicc && \
    mkdir ${PUBLIC}/ptscotch-${SCOTCH_VER} && \
    make install prefix=${PUBLIC}/ptscotch-${SCOTCH_VER} && \
    rm -rf /tmp/${SCOTCH_SRC} /tmp/patch_ptscotch /tmp/ptscotch

# Build parmetis
RUN wget --no-check-certificate --quiet ${PARMETIS_SRC} -O parmetis.tar.gz && \
    mkdir parmetis && tar xf parmetis.tar.gz -C parmetis --strip-components 1 && \
    cd parmetis && \
    make config prefix=${PUBLIC}/parmetis-${PARMETIS_VER} && \
    make && \
    make install && \
    rm -rf /tmp/parmetis.tar.gz /tmp/parmetis

# Build scalapack
RUN wget --no-check-certificate --quiet ${SCALAPACK_SRC} -O scalapack.tar.gz && \
    mkdir scalapack && tar xf scalapack.tar.gz -C scalapack --strip-components 1 && \
    cd scalapack && \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=${PUBLIC}/scalapack-${SCALAPACK_VER} -DBUILD_SHARED_LIBS=ON .. && \
    make && \
    make install && \
    cd ${PUBLIC}/scalapack-${SCALAPACK_VER}/lib && \
    cp libscalapack.so libblacs.so && \
    rm -rf /tmp/scalapack.tar.gz /tmp/scalapack

# Build parallel mumps
COPY --chown=aster:aster code_aster/data/patch_mumps /tmp/patch_mumps
RUN mkdir mumps && tar xf ${MUMPS_SRC} -C mumps --strip-components 1 && \
    patch -s -p0 < patch_mumps && \
    cd mumps && \
    export INCLUDES="${PUBLIC}/metis-${METIS_VER}/include \
                     ${PUBLIC}/parmetis-${PARMETIS_VER}/include \
                     ${PUBLIC}/ptscotch-${SCOTCH_VER}/include" && \
    export LIBPATH="${PUBLIC}/metis-${METIS_VER}/lib \
                    ${PUBLIC}/parmetis-${PARMETIS_VER}/lib \
                    ${PUBLIC}/ptscotch-${SCOTCH_VER}/lib \
                    ${PUBLIC}/scalapack-${SCALAPACK_VER}/lib" && \
    ./waf configure --prefix=${PUBLIC}/mumps-${MUMPS_VER}_mpi --install-tests --enable-mpi && \
    ./waf build --jobs=1 && \
    ./waf install --jobs=1 && \
    rm -rf /tmp/${MUMPS_SRC} /tmp/patch_mumps /tmp/mumps

# Build parallel PETSc
RUN wget --no-check-certificate --quiet ${PETSC_SRC} -O petsc.tar.gz && \
    mkdir petsc && tar xf petsc.tar.gz -C petsc --strip-components 1 && \
    cd petsc && \
    ./configure --COPTFLAGS="-O2" \
                --CXXOPTFLAGS="-O2" \
                --FOPTFLAGS="-O2" \
                --with-debugging=0 --with-shared-libraries=1 \
                --with-scalapack-dir=${PUBLIC}/scalapack-${SCALAPACK_VER} \
                --with-mumps-dir=${PUBLIC}/mumps-${MUMPS_VER}_mpi \
                --with-metis-dir=${PUBLIC}/metis-${METIS_VER} \
                --with-parmetis-dir=${PUBLIC}/parmetis-${PARMETIS_VER} \
                --with-ptscotch-dir=${PUBLIC}/ptscotch-${SCOTCH_VER} \
                --download-hypre --download-ml \
                --LIBS="-lgomp" \
                --prefix=${PUBLIC}/petsc-${PETSC_VER} && \
    make all && \
    make install && \
    rm -rf /tmp/petsc.tar.gz /tmp/petsc

# Build parallel aster
COPY --chown=aster:aster code_aster/data/cfg.py /tmp/cfg.py
RUN . ${ASTER_ROOT}/${ASTER_VER}/share/aster/profile_mfront.sh && \
    mkdir aster && tar xf ${ASTER_SRC} -C aster --strip-components 1 && \
    cd aster && \
    export INCLUDES="${PUBLIC}/hdf5-${HDF5_VER}/include \
                     ${PUBLIC}/med-${MED_VER}/include \
                     ${PUBLIC}/metis-${METIS_VER}/include \
                     ${PUBLIC}/parmetis-${PARMETIS_VER}/include \
                     ${PUBLIC}/ptscotch-${SCOTCH_VER}/include \
                     ${PUBLIC}/mumps-${MUMPS_VER}_mpi/include \
                     ${PUBLIC}/petsc-${PETSC_VER}/include \
                     ${PUBLIC}/tfel-${MFRONT_VER}/include" && \
    export LIBPATH="${PUBLIC}/hdf5-${HDF5_VER}/lib \
                    ${PUBLIC}/med-${MED_VER}/lib \
                    ${PUBLIC}/metis-${METIS_VER}/lib \
                    ${PUBLIC}/parmetis-${PARMETIS_VER}/lib \
                    ${PUBLIC}/ptscotch-${SCOTCH_VER}/lib \
                    ${PUBLIC}/scalapack-${SCALAPACK_VER}/lib \
                    ${PUBLIC}/mumps-${MUMPS_VER}_mpi/lib \
                    ${PUBLIC}/petsc-${PETSC_VER}/lib \
                    ${PUBLIC}/tfel-${MFRONT_VER}/lib" && \
    export METISDIR=${PUBLIC}/metis-${METIS_VER} && \
    export TFELHOME=${PUBLIC}/tfel-${MFRONT_VER} && \
    export GMSH_BIN_DIR=${PUBLIC}/gmsh-3.0.6-Linux64/bin && \
    export HOMARD_ASTER_ROOT_DIR=${PUBLIC}/homard-11.10 && \
    ./waf configure --use-config-dir=/tmp --use-config=cfg --prefix=${ASTER_ROOT}/${ASTER_VER}_mpi --install-tests --enable-mpi && \
    ./waf build && \
    ./waf install && \
    rm -rf /tmp/${ASTER_SRC} /tmp/cfg.py /tmp/aster

# Add a welcome message and a script for testcases
WORKDIR /home/aster
COPY code_aster/WELCOME /home/aster/WELCOME
COPY run_tests.sh /home/aster/run_tests.sh

RUN echo "vers : stable_mpi:${ASTER_ROOT}/${ASTER_VER}_mpi/share/aster" >> ${ASTER_ROOT}/etc/codeaster/aster && \
    echo "localhost" > ${ASTER_ROOT}/etc/codeaster/mpi_hostfile && \
    rm -rf /tmp/* && \
    echo "" >> .bashrc && \
    echo "source ~/aster/etc/codeaster/profile.sh" >> .bashrc && \
    echo "cat ~/WELCOME" >> .bashrc && \
    echo "echo" >> .bashrc

USER root
