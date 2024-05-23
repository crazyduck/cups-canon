#!/bin/bash
# printer config
PRINTER_NAME=ip7200
PRINTER_DESCRIPTION="Canon Pixma ip7200"
PRINTER_LOCATION="Buero"

PRINTER2_NAME=7065DN
PRINTER2_DESCRIPTION="Brother DCP-7065DN"
PRINTER2_LOCATION=$PRINTER_LOCATION
PRINTER2_PPD=canonip7200.ppd
PRINTER2_DEVPATH=cnijusb:/dev/usb/lp0

DEFAULT_PRINTER=$PRINTER2_NAME

# turn on bash's job control
set -m

# Start the cupsd foreground  process and put it in the background
echo "cupsd starting..."
/usr/sbin/cupsd -f &

# Check if printer already configured
FILE=/etc/cups/printers.conf
if [ -f "$FILE" ]; then
    echo "cupsd started..."
else 
    echo "First run, creating printer"
    sleep 5
    echo "waited 5 secs for cupsd to be up and responding"
    lpadmin -p $PRINTER_NAME -D "$PRINTER_DESCRIPTION" -E -L "$PRINTER_LOCATION" -m canonip7200.ppd -v cnijusb:/dev/usb/lp0
    #lpadmin -p $PRINTER2_NAME -D "$PRINTER2_DESCRIPTION" -E -L "$PRINTER2_LOCATION" -m $PRINTER2_PPD -v $PRINTER2_DEVPATH
    #lpoptions -d $DEFAULT_PRINTER
    echo "printer(s) created"
fi 

# now we bring the primary process back into the foreground
# and leave it there
fg %1
