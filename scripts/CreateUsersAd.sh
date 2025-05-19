#!/bin/bash

set -euo pipefail  # Exit on error, undefined variables, or pipe failure

LOG_FILE="/var/log/deploy_user_creation.log"
GROUP="deployG"
USERS=("Devo" "Testo" "Prodo")
BASE_HOME="/opt/deploy_users"

# Ensure log exists and is writable
if [[ ! -f "$LOG_FILE" ]]; then
    sudo touch "$LOG_FILE"
    sudo chmod 644 "$LOG_FILE"
fi

log() {
    echo "$1" | tee -a "$LOG_FILE"
}

log "Starting user/group setup at $(date)"

# Create group if it doesn't exist
if ! getent group "$GROUP" > /dev/null 2>&1; then
    log "Creating group $GROUP..."
    sudo groupadd "$GROUP"
else
    log "Group $GROUP already exists."
fi

# Process each user
for user in "${USERS[@]}"; do
    HOME_DIR="$BASE_HOME/$user"

    if id "$user" &>/dev/null; then
        log "User $user already exists. Skipping creation."
    else
        log "Creating user $user with home directory $HOME_DIR"
        sudo useradd -m -d "$HOME_DIR" -s /bin/rbash -g "$GROUP" "$user"
    fi

    # Ensure .ssh directory exists with correct permissions
    SSH_DIR="$HOME_DIR/.ssh"
    AUTH_KEYS="$SSH_DIR/authorized_keys"

    if [[ ! -d "$SSH_DIR" ]]; then
        log "Creating .ssh directory for $user"
        sudo mkdir -p "$SSH_DIR"
    fi
    sudo chmod 700 "$SSH_DIR"

    if [[ ! -f "$AUTH_KEYS" ]]; then
        log "Creating authorized_keys for $user"
        sudo touch "$AUTH_KEYS"
    fi
    sudo chmod 600 "$AUTH_KEYS"

    # Set correct ownership
    sudo chown -R "$user:$GROUP" "$HOME_DIR"

    # Lock password if not already locked
    if ! sudo passwd -S "$user" | grep -q "L"; then
        log "Locking password for $user"
        sudo passwd -l "$user"
    else
        log "Password already locked for $user"
    fi
done

log "User setup completed at $(date)"

