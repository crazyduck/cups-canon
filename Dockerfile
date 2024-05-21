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
  wget \
  libatk1.0-0 \
  libgtk2.0-0 \
  libpango1.0-0 \
  libpng12-0 \
  libtiff4 \
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

# Get Canon driver
RUN wget -O /tmp/ip7200-3.80-1-deb.tar.gz https://gdlp01.c-wss.com/gds/5/0100004655/01/cnijfilter-ip7200series-3.80-1-deb.tar.gz

# Untar driver
RUN tar -xvzf /tmp/ip7200-3.80-1-deb.tar.gz -C /tmp/

# Run driver installer
RUN /tmp/cnijfilter-ip7200series-3.80-1-deb/install.sh

# Clean install files
RUN rm -rf /tmp/cnijfilter-ip7200series-3.80-1-deb && rm /tmp/ip7200-3.80-1-deb.tar.gz

# Copy the default configuration file
COPY --chown=root:lp cupsd.conf /etc/cups/cupsd.conf

# Expose Ports
EXPOSE 631
EXPOSE 5353
EXPOSE 139

# Default shell
CMD ["/usr/sbin/cupsd", "-f"]
