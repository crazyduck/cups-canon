ARG MAINTAINER
FROM debian:stable-slim
MAINTAINER $MAINTAINER

ARG ADMINUSER
ARG ADMINPASS

# Install Packages (basic tools, cups, basic drivers, HP drivers)
RUN apt-get update \
&& apt-get install -y \
  sudo \
  whois \
  usbutils \
  cups \
  cups-client \
  cups-bsd \
  cups-filters \
  foomatic-db-compressed-ppds \
  printer-driver-all \
  openprinting-ppds \
  hpijs-ppds \
  hp-ppd \
  hplip \
  smbclient \
  printer-driver-cups-pdf \
  printer-driver-gutenprint \
  cups-backend-bjnp \
  wget \
  libatk1.0-0 \
  libgtk2.0-0 \
  libpango1.0-0 \
  #libpng12-0 \
  #libtiff4 \
  libxcursor1 \
  libxfixes3 \
  libxi6 \
  libxinerama1 \
  libxrandr2 \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# Add user and disable sudo password checking
RUN useradd \
  --groups=sudo,lp,lpadmin \
  --create-home \
  --home-dir=/home/$ADMINUSER \
  --shell=/bin/bash \
  --password=$(mkpasswd $ADMINPASS) \
  $ADMINUSER \
&& sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

# Get abandoned packages
RUN wget -O /tmp/libpng12-0_1.2.54-6_amd64.deb https://snapshot.debian.org/archive/debian/20160413T160058Z/pool/main/libp/libpng/libpng12-0_1.2.54-6_amd64.deb && dpkg -i /tmp/libpng12-0_1.2.54-6_amd64.deb
RUN wget -O /tmp/multiarch-support_2.28-10%2Bdeb10u3_amd64.deb https://snapshot.debian.org/archive/debian-security/20240503T212447Z/pool/updates/main/g/glibc/multiarch-support_2.28-10%2Bdeb10u3_amd64.deb && dpkg -i /tmp/multiarch-support_2.28-10%2Bdeb10u3_amd64.deb
RUN wget -O /tmp/libjpeg8_8d1-2_amd64.deb https://snapshot.debian.org/archive/debian/20141009T042436Z/pool/main/libj/libjpeg8/libjpeg8_8d1-2_amd64.deb && dpkg -i /tmp/libjpeg8_8d1-2_amd64.deb
RUN wget -O /tmp/libtiff4_3.9.7-3_amd64.deb https://snapshot.debian.org/archive/debian/20131205T220552Z/pool/main/t/tiff3/libtiff4_3.9.7-3_amd64.deb && dpkg -i /tmp/libtiff4_3.9.7-3_amd64.deb

# Get Canon driver and untar driver
RUN wget -O /tmp/ip7200-3.80-1-deb.tar.gz https://gdlp01.c-wss.com/gds/5/0100004655/01/cnijfilter-ip7200series-3.80-1-deb.tar.gz && tar -xf /tmp/ip7200-3.80-1-deb.tar.gz -C /tmp/

# Run driver installer
RUN dpkg -i /tmp/cnijfilter-ip7200series-3.80-1-deb/packages/*_amd64.deb

# Clean install files
RUN rm /tmp/*.deb
RUN rm -rf /tmp/cnijfilter-ip7200series-3.80-1-deb && rm /tmp/ip7200-3.80-1-deb.tar.gz


# Copy the default configuration file
COPY --chown=root:lp cupsd.conf /etc/cups/cupsd.conf
# Copy init.sh
COPY --chown=root:lp init.sh /init.sh

# Expose Ports
EXPOSE 631
EXPOSE 5353
EXPOSE 139

# Default shell
CMD ["sh","/init.sh"]
