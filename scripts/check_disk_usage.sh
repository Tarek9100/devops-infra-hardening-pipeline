#!/bin/bash

THRESHOLD=80
USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')

if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo "$(date): WARNING - Disk usage is at ${USAGE}%" >> /var/log/deploy_alerts.log
fi

