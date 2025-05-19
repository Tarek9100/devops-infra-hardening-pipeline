#!/bin/bash

GROUP="deployG"
echo "Users NOT in group '$GROUP':"
printf "%-12s %-6s %-16s %s\n" "Username" "UID" "Shell" "Last Login"

NOT_IN_GROUP=0

while IFS=: read -r user _ uid _ _ _ _; do
    # Filter out system accounts (UID < 1000)
    USER_ID=$(id -u "$user" 2>/dev/null)
    if [[ -n "$USER_ID" && "$USER_ID" =~ ^[0-9]+$ && "$USER_ID" -ge 1000 ]]; then
        PRIMARY_GROUP=$(id -gn "$user")
        if [[ "$PRIMARY_GROUP" != "$GROUP" ]] && ! getent group "$GROUP" | grep -q "\b$user\b"; then
            SHELL=$(getent passwd "$user" | awk -F: '{print $7}')
            LASTLOGIN=$(lastlog -u "$user" | awk 'NR==2 {if ($0 ~ /Never/) print "Never logged in"; else print $4, $5, $6, $7}')
            printf "%-12s %-6s %-16s %s\n" "$user" "$USER_ID" "$SHELL" "$LASTLOGIN"
            ((NOT_IN_GROUP++))
        fi
    fi
done < /etc/passwd

echo -e "\nTotal users not in $GROUP: $NOT_IN_GROUP"

