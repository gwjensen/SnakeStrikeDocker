#!/bin/bash -e

# Parameters
IMAGE=hostmot2-builder
NAME=${IMAGE}
TOPDIR="$(readlink -f $(dirname $0))"
UID_GID=`id -u`:`id -g`

# Check for existing containers
EXISTING="$(docker ps -aq --filter=name=${NAME}\$)"
if test -n "${EXISTING}"; then
    # Container exists; is it running?
    RUNNING=$(docker inspect ${EXISTING} | awk '/"Running":/ { print $2 }')
    if test "${RUNNING}" = "false,"; then
	# Remove stopped container
	echo docker rm ${EXISTING}
    elif test "${RUNNING}" = "true,"; then
	# Container already running; error
	echo "Error:  container '${NAME}' already running" >&2
	exit 1
    else
	# Something went wrong
	echo "Error:  unable to determine status of " \
	    "existing container '${EXISTING}'" >&2
	exit 1
    fi
fi



test -d "${TOPDIR}/Xilinx" || mkdir -p "${TOPDIR}/Xilinx"
set -x
#exec docker run --rm \
#    -it --privileged \
#    -u "$UID_GID" \
#    -v /tmp/.X11-unix:/tmp/.X11-unix \
#    -v /dev/dri:/dev/dri \
#    -v "$HOME":"$HOME" \
#    -v "$TOPDIR":"$TOPDIR" \
#    -v "$TOPDIR/Xilinx":"/opt/Xilinx" \
#    -w "$TOPDIR" \
#    -e DISPLAY \
#    -h ${NAME} --name ${NAME} \
#    ${IMAGE} "$@"
    
exec docker run --rm \
    -it --privileged \
    -u "$UID_GID" \
    -v /dev/dri:/dev/dri \
    -v "$HOME":"$HOME" \
    -v env_setup.sh:/env_setup.sh \
    -h ${NAME} --name ${NAME} \
    ${IMAGE} "$@"
