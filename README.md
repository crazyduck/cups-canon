# cups-canon Docker compose
Docker compose Cups profile for Canon pixma ip7200

Container will deploy a cups daemon which has a Canon Pixma ip7200 printer configured by default.

Canon Pixma ip7200 will be connected by USB and available on host at /bus/usb/lp0.

### Customization
Following variables may be overwritten by ENV variables

Cups admin user credentials:
 - ADMINUSER (default: print)
 - ADMINPASS (default: printpass)

Printer settings:
 - PRINTER_NAME (default: ip7200)
 - PRINTER_DESCRIPTION (default: Canon Pixma ip7200)
 - PRINTER_LOCATION (default: Buero)

## How to make printer accessible in LXC and docker

https://forums.unraid.net/topic/139444-solved-getting-custom-udev-rule-to-work/?do=findComment&comment=1263707
