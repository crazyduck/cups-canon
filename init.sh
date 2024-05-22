#!/bin/bash
  

# printer config
PRINTER_NAME=ip7200
PRINTER_DESCRIPTION="Canon Pixma ip7200"
PRINTER_LOCATION="Buero"
# Start the cupsd foreground  process and put it in the background
  
# Check if printer already configured
FILE=/etc/cups/printers.conf
if [ -f "$FILE" ]; then
    echo "cupsd starting..."
    /usr/sbin/cupsd -f
else 
    echo "First run, creating printer"
    echo "starting cupsd in daemon mode for this run"
    /usr/sbin/cupsd
    lpadmin -p $PRINTER_NAME -D "$PRINTER_DESCRIPTION" -E -L "$PRINTER_LOCATION" -m canonip7200.ppd -v cnijusb:/dev/usb/lp0
    echo "printer created"
fi 
# now we bring the primary process back into the foreground
# and leave it there
