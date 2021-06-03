#!/bin/sh

[ ! -d /wmbusmeters_data/logs/meter_readings ] && mkdir -p /wmbusmeters_data/logs/meter_readings
[ ! -d /wmbusmeters_data/etc/wmbusmeters.d ] && mkdir -p /wmbusmeters_data/etc/wmbusmeters.d
[ ! -f /wmbusmeters_data/etc/wmbusmeters.conf ] && echo -e "loglevel=normal\ndevice=auto\nlistento=t1\nlogtelegrams=false\nformat=json\nmeterfiles=/wmbusmeters_data/logs/meter_readings\nmeterfilesaction=overwrite\nlogfile=/wmbusmeters_data/logs/wmbusmeters.log" > /wmbusmeters_data/etc/wmbusmeters.conf

function shutdown {
    kill -TERM $WMBUSMETERS_PID
    rm /var/run/wmbusmeters.pid
    wait $WMBUSMETERS_PID
}

/wmbusmeters/wmbusmeters --useconfig=/wmbusmeters_data &
WMBUSMETERS_PID=$!
echo $WMBUSMETERS_PID > /var/run/wmbusmeters.pid

trap shutdown SIGTERM SIGINT
wait $WMBUSMETERS_PID

