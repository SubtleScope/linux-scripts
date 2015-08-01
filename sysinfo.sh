#!/bin/bash

echo "CPU Model:             `grep -m1 'model name' /proc/cpuinfo | cut -d' ' -f3- | tr -s ' '`"
echo "CPU/Core Speed (MHz):  `grep -m1 'cpu MHz' /proc/cpuinfo | cut -d' ' -f3` MHz"
echo "RAM:                   `grep 'MemTotal' /proc/meminfo | awk '{ print $2,$3 }'`"
echo "Operating System:      `uname -sr`"
echo "javac version:         `javac -version 2>&1`"
