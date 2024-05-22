#!/bin/bash
# printer config
PRINTER_NAME=ip7200
PRINTER_DESCRIPTION="Canon Pixma ip7200"
PRINTER_LOCATION="Buero"

# turn on bash's job control
set -m

# Start the cupsd foreground  process and put it in the background
/usr/sbin/cupsd -f &

# Check if printer already configured
FILE=/etc/cups/printers.conf
if [ -f "$FILE" ]; then
    echo "cupsd starting..."
else 
    echo "First run, creating printer"
    lpadmin -p $PRINTER_NAME -D "$PRINTER_DESCRIPTION" -E -L "$PRINTER_LOCATION" -m canonip7200.ppd -v cnijusb:/dev/usb/lp0
    echo "printer created"
fi 

# now we bring the primary process back into the foreground
# and leave it there
fg %1
