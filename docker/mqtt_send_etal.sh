#!/bin/bash
METER_ID="$1"
METER_JSON="$2"
/usr/bin/mosquitto_pub -h 10.10.1.4 -t wmbusmeters/$METER_ID -m "$METER_JSON"

/root/restart_cul.sh &

