#!/bin/sh

sudo chmod +x init_perf.sh
sudo cp init_perf.sh /etc/init.d
sudo update-rc.d init_perf.sh defaults
