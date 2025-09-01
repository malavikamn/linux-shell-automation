#!/bin/bash
# Author: MALAVIKA
# Description: Daily System Performance Monitoring Script

LOGFILE="/var/log/system-health-$(date +%F).log"
HOSTNAME=$(hostname)
DATE=$(date)

{
  echo "============================================"
  echo " System Health Report for $HOSTNAME"
  echo " Generated on: $DATE"
  echo "============================================"

  # Disk Usage
  echo -e "\nDisk Usage:"
  df -h --output=source,size,used,avail,pcent,target | tail -n +2

  # CPU Load
  echo -e "\nCPU Load (1/5/15 min average):"
  uptime | awk -F'load average:' '{ print "  " $2 }'

  # Memory Usage
  echo -e "\nMemory Usage:"
  free -h | awk 'NR==1 || /Mem|Swap/ { printf "  %-10s %-10s %-10s %-10s %-10s %-10s\n", $1, $2, $3, $4, $5, $6 }'

  # Failed Services
  echo -e "\nFailed Systemd Services:"
  systemctl --failed --no-pager

  # Top Resource-Hungry Processes
  echo -e "\nTop 5 CPU & Memory Consuming Processes:"
  ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6

  # System Uptime
  echo -e "\nSystem Uptime:"
  uptime -p

} >> "$LOGFILE"
