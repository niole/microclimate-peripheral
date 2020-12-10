#!/bin/bash
nohup ./setup_peripheral.py > /tmp/peripheral.log 2>&1 &

echo $! > save_setup_peripheral_pid.txt
