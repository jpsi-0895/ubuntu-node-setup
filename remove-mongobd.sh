  GNU nano 7.2                                                            re-mangodb.sh                                                                     #!/bin/bash
set -euo pipefail

# ===========================================
# MongoDB Full Removal Script (Ubuntu)
# This will:
#   - Stop MongoDB service
#   - Remove MongoDB packages
#   - Delete configuration, logs, and data
#   - Remove repo sources & GPG key
# ===========================================

echo ">>> Stopping MongoDB service (if running)..."
sudo systemctl stop mongod || true
sudo systemctl disable mongod || true

echo ">>> Purging MongoDB packages..."
sudo apt-get purge -y mongodb-org* mongodb* mongosh* mongocli* || true

echo ">>> Removing leftover dependencies..."
sudo apt-get autoremove -y
sudo apt-get autoclean -y

echo ">>> Removing MongoDB data, logs, and configs..."
sudo rm -rf /var/log/mongodb
sudo rm -rf /var/lib/mongodb
sudo rm -rf /etc/mongod.conf /etc/mongodb.conf
sudo rm -rf /etc/mongod.conf.orig /etc/mongodb.conf.orig

echo ">>> Removing MongoDB apt repo sources..."
sudo rm -f /etc/apt/sources.list.d/mongodb*.list
sudo rm -f /usr/share/keyrings/mongodb-server.gpg

echo ">>> MongoDB has been completely removed from this system."
