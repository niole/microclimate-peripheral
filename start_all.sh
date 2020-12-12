#!/usr/bin/env bash

python3.5 -m pip install -r requirements.txt

nohup ./runpi.sh &
echo $! > save_pid.txt

./runperipheralserver.sh
