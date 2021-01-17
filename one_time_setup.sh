#!/bin/sh

sudo cp init_perf.sh /etc/init.d
sudo chmod +x /etc/init.d/init_perf.sh
sudo update-rc.d init_perf.sh defaults
