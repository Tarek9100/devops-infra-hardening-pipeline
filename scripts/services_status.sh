#!/bin/bash

echo -e "Service\t\t\tMemory Usage"
echo "------------------------------------------"

# Skip header and select active service names
systemctl list-units --type=service --state=running | awk 'NR>1 {print $1}' | grep '\.service$' | while read service; do
    pid=$(systemctl show "$service" | grep ^MainPID= | cut -d= -f2)
    if [[ "$pid" != "0" && -n "$pid" ]]; then
        mem=$(ps -p "$pid" -o rss= 2>/dev/null | awk '{printf "%.2f MB", $1/1024}')
        printf "%-24s %s\n" "$service" "$mem"
    fi
done
