#!/bin/bash
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/cert.pem
#export NIOLE_MBP_HOSTNAME="ec2-35-161-83-246.us-west-2.compute.amazonaws.com"
nohup ./LED.py > led.log 2>&1 &
echo $! > save_pid.txt
