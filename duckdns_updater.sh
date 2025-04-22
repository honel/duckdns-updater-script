#!/bin/bash

# -------------------------------------------------------------------
# DuckDNS Updater Script for Raspberry Pi
# 
# This script checks your current public IP and updates your DuckDNS
# domain if the IP has changed. It logs the changes to a local file.
# 
# Reference: https://github.com/honel/duckdns-updater-script/
# -------------------------------------------------------------------

# === CONFIGURATION ===
DUCKDNS_DOMAIN="your-subdomain"     # Replace with your DuckDNS subdomain
DUCKDNS_TOKEN="your-token"          # Replace with your DuckDNS token
LOG_FILE="/var/log/duckdns_updater.log"
LAST_IP_FILE="/var/tmp/last_duckdns_ip.txt"

# === Get current public IP ===
CURRENT_IP=$(curl -s https://api.ipify.org)

# === Check if IP was retrieved ===
if [[ -z "$CURRENT_IP" ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: Failed to retrieve public IP" >> "$LOG_FILE"
    exit 1
fi

# === Load last known IP ===
if [[ -f "$LAST_IP_FILE" ]]; then
    LAST_IP=$(cat "$LAST_IP_FILE")
else
    LAST_IP="(none)"
fi

# === If IP changed, update DuckDNS and log ===
if [[ "$CURRENT_IP" != "$LAST_IP" ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - IP changed from $LAST_IP to $CURRENT_IP" >> "$LOG_FILE"

    UPDATE_URL="https://www.duckdns.org/update?domains=$DUCKDNS_DOMAIN&token=$DUCKDNS_TOKEN&ip=$CURRENT_IP"
    RESPONSE=$(curl -s "$UPDATE_URL")

    if [[ "$RESPONSE" == "OK" ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - DuckDNS update successful" >> "$LOG_FILE"
        echo "$CURRENT_IP" > "$LAST_IP_FILE"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: DuckDNS update failed, response: $RESPONSE" >> "$LOG_FILE"
    fi
fi
