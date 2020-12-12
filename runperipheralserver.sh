#!/bin/bash
nohup ./setup_peripheral.py &

echo $! > save_setup_peripheral_pid.txt
