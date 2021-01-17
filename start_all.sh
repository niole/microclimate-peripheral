#!/bin/bash

source ./env_vars.sh

python3.5 -m pip install -r requirements.txt

./run_led.sh
./runperipheralserver.sh
