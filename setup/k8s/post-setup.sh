#!/bin/bash
# Script: firstrun-script.sh
# Description: Executes one-time setup tasks after OS installation.

LOG_FILE="/var/log/post-setup.log"
NEW_HOSTNAME="debian-server"
EXIT_STATUS=0
# --- END VARIABLES ---

# Start the log file, overwriting any previous content (though it shouldn't exist)
echo "Starting one-time server setup script..." > "$LOG_FILE"
date >> "$LOG_FILE"
echo "-------------------------------------" >> "$LOG_FILE"

/usr/bin/apt-get update >> "$LOG_FILE" 2>&1
/usr/bin/apt-get install -y sudo vim net-tools openssh-server ifupdown >> "$LOG_FILE" 2>&1 || EXIT_STATUS=$?

update-alternatives --set editor /usr/bin/vim.basic >> "$LOG_FILE" 2>&1 || EXIT_STATUS=$?

# ---------

SSH_CONFIG="/etc/ssh/sshd_config"

sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/' "$SSH_CONFIG" || EXIT_STATUS=$?
sed -i 's/KerberosAuthentication yes/KerberosAuthentication no/' "$SSH_CONFIG" || EXIT_STATUS=$?
systemctl restart sshd >> "$LOG_FILE" 2>&1 || EXIT_STATUS=$?

# ---------

LOGIND_CONF="/etc/systemd/logind.conf"

sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=ignore/' "$LOGIND_CONF" || EXIT_STATUS=$?
sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' "$LOGIND_CONF" || EXIT_STATUS=$?
sed -i 's/#HandleLidSwitchDocked=ignore/HandleLidSwitchDocked=ignore/' "$LOGIND_CONF" || EXIT_STATUS=$?
sed -i 's/#IdleAction=suspend/IdleAction=ignore/' "$LOGIND_CONF" || EXIT_STATUS=$?

systemctl restart systemd-logind >> "$LOG_FILE" 2>&1 || EXIT_STATUS=$?

# Log the completion status
echo "-------------------------------------" >> "$LOG_FILE"
echo "Script finished with exit status: $EXIT_STATUS" >> "$LOG_FILE"

# Clear the screen after systemd is disabled (Optional: helps cleanup console history)
/usr/bin/clear

# The final exit status determines if ExecStartPost runs. Use the collected status.
exit $EXIT_STATUS
