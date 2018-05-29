FROM phusion/baseimage:0.9.22

# Get Ubuntu updates
USER root
RUN apt-get update && \
    apt-get upgrade -y --with-new-pkgs -o Dpkg::Options::="--force-confold" && \
    apt-get install -y locales sudo

# Get basic packages
RUN apt-get install -y \
    gcc g++ gfortran \
    wget \
    python \
    python-dev \
    python-numpy \
    python-qt4 \
    libxft2 \
    libxss1

RUN echo "C.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set locale environment
ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8

# Add a new user
RUN adduser --disabled-password --gecos "" aster
RUN adduser aster sudo
RUN echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Turn off forwarding of syslog messages to stdout
# https://github.com/phusion/baseimage-docker/issues/186
RUN touch /etc/service/syslog-forwarder/down

# Create a sharable zone
USER aster
RUN touch /home/aster/.sudo_as_admin_successful && \
    mkdir /home/aster/shared
VOLUME /home/aster/shared

WORKDIR /home/aster
USER root
ENTRYPOINT ["/sbin/my_init", "--quiet", "--", "/sbin/setuser", "aster", "/bin/bash", "-l", "-c"]
CMD ["/bin/bash", "-i"]
