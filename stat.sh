#!/bin/bash

# CPU USAGE , display with %
CPU=$(top -bn1 | grep "Cpu(s)" | \
           sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
           awk '{print 100 - $1"%"}')

# Mem usage
MEM=$(free -m | awk 'NR==2{printf "%sM\n", $3}')

#Disk avail
DISK=$(df -h | awk '$NF=="/"{printf "%dGB\n", $4}')
printf "%s\n" "$CPU $MEM $DISK"
