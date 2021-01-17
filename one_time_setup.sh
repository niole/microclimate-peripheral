#!/bin/sh

sudo cp init_perf.sh /etc/init.d
sudo cp env_vars.sh /etc/init.d
sudo update-rc.d init_perf.sh defaults
