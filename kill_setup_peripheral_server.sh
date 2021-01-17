#!/bin/bash

setup_pid=$(ps aux | grep setup_peripheral | head -n 1 | awk '{print $2}')
kill -9 $setup_pid
