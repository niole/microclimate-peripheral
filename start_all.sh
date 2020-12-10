#!/usr/bin/env bash

python3.5 -m pip install -r requirements.txt

nohup ./runpi.sh > /tmp/led.log 2>&1 &
echo $! > save_pid.txt

./runperipheralserver.sh
