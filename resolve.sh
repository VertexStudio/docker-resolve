#!/bin/sh

GLXINFO=$(glxinfo -B) || { echo "ERROR: 'glxinfo' command not found. please install it."; exit; }
if [ "$(echo $GLXINFO | grep 'Mesa DRI')" ] ; then MESA="/mesa" ; else MESA="" ; fi

XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

docker run --rm -ti --network=none \
    --runtime=nvidia \
    --user $(id -u):$(id -g) \
    --privileged \
    -e DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e XAUTHORITY=$XAUTH \
    -v $XAUTH:$XAUTH \
    -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
	-v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
    -v resolve_configs_$USER:/opt/resolve/configs \
    -v resolve_database_$USER:/opt/resolve/Resolve\ Disk\ Database \
    -v resolve_logs_$USER:/opt/resolve/logs \
    -v /srv/archive/test:/opt/resolve/Media \
    registry.gitlab.com/mash-graz/resolve$MESA $*
