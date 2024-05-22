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

# rebuild abondoned packages
# libtiff4
RUN wget -O /tmp/tiff-4.6.0rc2.tar.xz https://download.osgeo.org/libtiff/tiff-4.6.0rc2.tar.xz && tar -xf /tmp/tiff-4.6.0rc2.tar.xz -c /tmp/

# libpng12
RUN wget -O /tmp/libpng-1.2.59.tar.xz https://altushost-swe.dl.sourceforge.net/project/libpng/libpng12/1.2.59/libpng-1.2.59.tar.xz && tar -xf /tmp/libpng-1.2.59.tar.xz -c /tmp/

# Get old packages
RUN wget -O /tmp/libpng12-0_1.2.54-6_amd64.deb https://snapshot.debian.org/archive/debian/20160413T160058Z/pool/main/libp/libpng/libpng12-0_1.2.54-6_amd64.deb
RUN wget -O /tmp/libtiff4_3.9.7-3_amd64.deb https://snapshot.debian.org/archive/debian/20131205T220552Z/pool/main/t/tiff3/libtiff4_3.9.7-3_amd64.deb

# Get Canon driver and untar driver
RUN wget -O /tmp/ip7200-3.80-1-deb.tar.gz https://gdlp01.c-wss.com/gds/5/0100004655/01/cnijfilter-ip7200series-3.80-1-deb.tar.gz && tar -xf /tmp/ip7200-3.80-1-deb.tar.gz -C /tmp/

# Run driver installer
# temp disabled
#RUN /tmp/cnijfilter-ip7200series-3.80-1-deb/install.sh

# Clean install files
#RUN rm -rf /tmp/libpng-1.2.59 && rm /tmp/libpng-1.2.59.tar.xz
#RUN rm -rf /tmp/tiff-4.6.0 && rm /tmp/tiff-4.6.0rc2.tar.xz
#RUN rm -rf /tmp/cnijfilter-ip7200series-3.80-1-deb && rm /tmp/ip7200-3.80-1-deb.tar.gz

# Copy the default configuration file
COPY --chown=root:lp cupsd.conf /etc/cups/cupsd.conf

# Expose Ports
EXPOSE 631
EXPOSE 5353
EXPOSE 139

# Default shell
CMD ["/usr/sbin/cupsd", "-f"]
