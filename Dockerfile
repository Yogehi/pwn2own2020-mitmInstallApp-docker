# setup stuff required to host hotspot and host payload HTMLs

FROM kalilinux/kali-rolling
RUN apt-get update && \
        apt-get install \
        apt-utils \
        -y
RUN apt-get install \
        procps \
        hostapd \
        iproute2 \
        iw \
        haveged \
        dnsmasq \
        iptables \
        git \
        libgtk-3-dev \
        build-essential \
        cmake \
        gcc \
        g++ \
        pkg-config \
        make \
        usbutils \
        apache2 \
        python3-pip \
        -y
RUN git clone https://github.com/lakinduakash/linux-wifi-hotspot /tmp/linux-wifi-hotspot
RUN cd /tmp/linux-wifi-hotspot && make && make install
COPY html /var/www/html
RUN pip3 install requests
RUN pip3 install sockets

################################################################

# copy script

COPY bin /usr/bin
RUN chmod +x /usr/bin/pwn
