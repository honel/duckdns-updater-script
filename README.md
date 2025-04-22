🧰 Step-by-Step Setup

1. 📁 Create a directory for the script:
    >> mkdir -p ~/duckdns; cd ~/duckdns

2. 📝 Download the script file
    >> wget https://raw.githubusercontent.com/honel/duckdns-updater-script/refs/heads/main/duckdns_update.sh

3. 📂 Edit the script:
Use your actual DUCKDNS_DOMAIN and DUCKDNS_TOKEN.

  - Example placeholders to replace:
    >> DUCKDNS_DOMAIN="myraspberrypi"
    >> DUCKDNS_TOKEN="abc123def456ghi789"
  
 If you are running the script not as root make the following changes.
  - Edit the script lines 6 and 7:
    >> LOG_FILE="/var/log/duckdns_updater.log"
    >> LAST_IP_FILE="/var/tmp/last_duckdns_ip.txt
    Change them to:
    >> LOG_FILE="$HOME/duckdns/duckdns_updater.log"
    >> LAST_IP_FILE="$HOME/duckdns/last_duckdns_ip.txt

 This avoids any need for root access.

4. ✅ Make the script executable
   >> chmod +x duckdns_update.sh

5. 🔁 Set up a cron job (as your user)
Open your user’s crontab:
   >> crontab -e

Add this line (without ">>") at the end to run it every 5 minutes:
  >> */5 * * * * ~/duckdns/duckdns_update.sh

6. 🔍 Check if it works
After a few minutes, check the log:
cat ~/duckdns/duckdns_updater.log

You should see lines like:
>> 2025-04-22 11:25:00 - IP changed from (none) to 203.0.113.42
>> 2025-04-22 11:25:01 - DuckDNS update successful

🧠 Notes:
 You can also tail the log and follow changes as they happen:
 >> tail -f ~/duckdns/duckdns_updater.log

The script will only log when the IP changes or something goes wrong.
