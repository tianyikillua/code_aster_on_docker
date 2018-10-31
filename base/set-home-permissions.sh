#!/bin/bash
# User can pass e.g. --env HOST_UID=1003 so that UID in the container matches
# with the UID on the host.
if [ "$HOST_UID" ]; then
    usermod -u $HOST_UID aster
fi
if [ "$HOST_GID" ]; then
    groupmod -g $HOST_GID aster
fi
