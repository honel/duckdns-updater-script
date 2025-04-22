# 📝 Script Description
This script automatically updates your DuckDNS domain with your current public IP address. It is designed to run on a Raspberry Pi (or any Linux system) and ensures your DuckDNS hostname always points to your correct external IP — useful when your home internet IP changes.

# 🔍 How it works:
1. Fetches your public IP:  The script detects your current external (WAN) IP address by using the following external service:
```https://api.ipify.org```

2. Checks for changes:
It compares the current IP with the last recorded IP (stored in a local file).

3. Updates DuckDNS only when needed:
If the IP has changed, it sends an update request to DuckDNS. If the update is successful, it logs the change and saves the new IP. If the IP hasn’t changed, it does nothing (no log, no update).

4. Logs actions: 
It only logs events when the IP changes or if there’s an error. Logs include date, time, old IP, new IP, and the result of the update attempt.

5. Runs automatically via cron: 
You schedule it with cron to run every few minutes, keeping your DuckDNS address up-to-date without manual effort.

# 🧰 Step-by-Step Setup
1. 📁 Create a directory for the script:
```
mkdir -p ~/duckdns; cd ~/duckdns
```

3. 📝 Download the script file
```
wget https://raw.githubusercontent.com/honel/duckdns-updater-script/refs/heads/main/duckdns_update.sh
```

5. 📂 Edit the script:
Use your actual `DUCKDNS_DOMAIN` and `DUCKDNS_TOKEN`.

- Example placeholders to replace:
```
DUCKDNS_DOMAIN="myraspberrypi"
DUCKDNS_TOKEN="abc123def456ghi789
```
  
If you are running the script not as root make the following changes.

- Edit the script lines 6 and 7:
```
LOG_FILE="/var/log/duckdns_updater.log"
LAST_IP_FILE="/var/tmp/last_duckdns_ip.txt"
```

Change them to:
```
LOG_FILE="$HOME/duckdns/duckdns_updater.log"
LAST_IP_FILE="$HOME/duckdns/last_duckdns_ip.txt"
```

This avoids any need for root access.

4. ✅ Make the script executable
```
chmod +x duckdns_update.sh
```

5. 🔁 Set up a cron job (as your user)
Open your user’s crontab:
```
crontab -e
```

Add the last line to the end of your cron job list to run it every 5 minutes:
```
# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of week (0 - 7) (Sunday=0 or 7)
# │ │ │ │ │
# │ │ │ │ │
*/5 * * * * ~/duckdns/duckdns_update.sh  # runs every 5 minutes
```

6. 🔍 Check if it works
After a few minutes, check the log:
> cat ~/duckdns/duckdns_updater.log

You should see lines like:
```
2025-04-22 11:25:00 - IP changed from (none) to 203.0.113.42
2025-04-22 11:25:01 - DuckDNS update successful
```

🧠 Notes:
You can also tail the log and follow changes as they happen:
```
tail -f ~/duckdns/duckdns_updater.log
```

The script will only log when the IP changes or something goes wrong.
