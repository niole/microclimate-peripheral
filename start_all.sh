#!/bin/bash

export LC_ALL=C

source ./env_vars.sh

python3.7 -m pip install -v -r ./requirements.txt

./run_led.sh
./runperipheralserver.sh
