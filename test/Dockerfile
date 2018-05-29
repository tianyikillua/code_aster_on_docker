FROM quay.io/tianyikillua/code_aster:latest
LABEL maintainer "Tianyi Li <tianyikillua@gmail.com>"

# Copy the script and run all testcases
USER aster
WORKDIR /home/aster
COPY run_tests.sh /home/aster/run_tests.sh
RUN bash run_tests.sh
