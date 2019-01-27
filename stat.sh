#!/bin/bash

# CPU USAGE , display with %
top -bn1 | grep "Cpu(s)" | \
           sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
           awk '{print 100 - $1"%"}'

# Mem usage
free -m | awk 'NR==2{printf "%sM \n", $3}'

#Disk avail
df -h | awk '$NF=="/"{printf "%d GB\n", $4}'
