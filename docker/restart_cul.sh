#!/bin/bash

USB_SW="http://10.10.1.116/"
CMD="cm?cmnd="
ON="Power%20on"
OFF="Power%20off"

############

handle_err()
{
        ERRNO=$1
        if [ "$ERRNO" -eq "3"]; then echo "FATAL:  Stromschaltfehler!"; exit 3; 
        elsif [ "$ERRNO" -eq "2"]; echo "FATAL:  USBDRV nicht gefunden"; 
        elsif [ "$ERRNO" -eq "1"]; echo "Backupdrive nicht gemountet"
        fi
}

sleep 3;

PWRSTATUS=""
PWRSTATUS=`/usr/bin/curl -s ${USB_SW}${CMD}${OFF} | /usr/bin/jq -r .POWER`
if [ "$PWRSTATUS" != "OFF" ]; then
        ERRORNO=3;
        handle_err $ERRORNO
else 
	echo "Powerstatus = $PWRSTATUS"

fi

sleep 3

if [ -e /var/run/wmbusmeters.pid ]; then
    kill -HUP $(cat /var/run/wmbusmeters.pid)
fi

sleep 10;

PWRSTATUS=`/usr/bin/curl -s ${USB_SW}${CMD}${ON} | /usr/bin/jq -r .POWER`
if [ "$PWRSTATUS" != "ON" ]; then
        ERRORNO=3;
        handle_err $ERRORNO
else 
	echo "Powerstatus = $PWRSTATUS"

fi




