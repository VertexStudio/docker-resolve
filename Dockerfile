ARG from

FROM ${from}

ARG mesa

RUN yum -y install  usbutils pciutils psmisc bzip2 unzip rsync \
    ${mesa} glx-utils mesa-libGLU libXmu libXi libSM freetype librsvg2  \
    alsa-lib   alsa-plugins-pulseaudio libgomp libxkbcommon fuse-libs \
    && yum -y install epel-release \
    && yum -y install ocl-icd clinfo xorriso \
    && rm -rf /var/cache/yum/*

RUN mkdir -p /etc/OpenCL/vendors \
    && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

COPY DaVinci_Resolve_*_Linux.zip /tmp/
RUN  alias zenity=echo \
    && cd /tmp \
    && mkdir unpack \
    && unzip DaVinci_Resolve_*_Linux.zip \
    && mkdir -p /root/Desktop/DaVinci \
    && xorriso -osirrox on -indev ./DaVinci_Resolve_*_Linux.run -extract / unpack \
    && unpack/AppRun -i -a -y \
    && rm -rf unpack DaVinci_Resolve_*_Linux.* Linux_Installation_Instructions.pdf

RUN dbus-uuidgen > /etc/machine-id

VOLUME ["/opt/resolve/configs", "/opt/resolve/Resolve Disk Database", "/opt/resolve/logs"]

USER nobody:nobody
CMD /opt/resolve/bin/resolve

# nvidia-container-runtime 
ENV NVIDIA_VISIBLE_DEVICES all 
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},display,video
