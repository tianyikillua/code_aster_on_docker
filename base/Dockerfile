FROM phusion/baseimage:0.10.1

# Get Ubuntu updates and basic packages
USER root
RUN apt-get update && \
    apt-get upgrade -y --with-new-pkgs -o Dpkg::Options::="--force-confold" && \
    apt-get install -y \
    locales sudo \
    gcc g++ gfortran \
    wget \
    python \
    python-dev \
    python-numpy \
    python-qt4 \
    libxft2 \
    libxss1 && \
    echo "C.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set locale environment
ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8

COPY set-home-permissions.sh /etc/my_init.d/set-home-permissions.sh

# Add a new user
RUN adduser --disabled-password --gecos "" aster && \
    adduser aster sudo && \
    echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    rm /etc/my_init.d/10_syslog-ng.init && \
    chmod +x /etc/my_init.d/set-home-permissions.sh 

# Create a sharable zone
USER aster
RUN touch /home/aster/.sudo_as_admin_successful && \
    mkdir /home/aster/shared
VOLUME /home/aster/shared

WORKDIR /home/aster
USER root
ENTRYPOINT ["/sbin/my_init", "--quiet", "--", "/sbin/setuser", "aster", "/bin/bash", "-l", "-c"]
CMD ["/bin/bash", "-i"]
