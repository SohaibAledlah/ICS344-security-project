#!/bin/bash

# Configurable variables
LOG_FILE="/var/log/apache2/access.log"
ALERT_LOG="/var/log/honeypot_alerts.log"
MAX_ATTEMPTS=5
BLOCKED_IPS_FILE="/var/log/blocked_ips.txt"

# Function to block an IP using iptables
block_ip() {
    local ip="$1"
    sudo iptables -A INPUT -s "$ip" -j DROP
    echo "$(date) - [BLOCKED] IP $ip blocked after exceeding $MAX_ATTEMPTS failed attempts" | tee -a "$ALERT_LOG"
    echo "$ip" >> "$BLOCKED_IPS_FILE"
}

# Monitor log file and track failed attempts
monitor_log() {
    declare -A failed_attempts

    tail -Fn0 "$LOG_FILE" | while read -r line; do
        # Extract IP and status code
        ip=$(echo "$line" | awk '{print $1}')
        status=$(echo "$line" | awk '{print $9}')

        # Check for failed login attempts (HTTP status 200 = failure in honeypot)
        if [[ "$status" == "200" ]]; then
            # Increment failure count for the IP
            failed_attempts["$ip"]=$((failed_attempts["$ip"] + 1))
            echo "$(date) - [ALERT] Failed login attempt from IP $ip (${failed_attempts[$ip]} attempts)" >> "$ALERT_LOG"

            # Block IP if it exceeds the max allowed attempts
            if [[ "${failed_attempts["$ip"]}" -ge "$MAX_ATTEMPTS" ]]; then
                if ! grep -q "$ip" "$BLOCKED_IPS_FILE"; then
                    block_ip "$ip"
                    unset failed_attempts["$ip"]  # Reset counter after blocking
                fi
            fi
        fi

        # Remove IP from tracking if it succeeds (HTTP status 302 = success)
        if [[ "$status" == "302" ]]; then
            unset failed_attempts["$ip"]
        fi
    done
}

# Run the monitoring function
monitor_log
