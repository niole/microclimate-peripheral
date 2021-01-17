#!/bin/bash

led_pid=$(ps aux | grep LED | head -n 1 | awk '{print $2}')
kill -9 $led_pid
