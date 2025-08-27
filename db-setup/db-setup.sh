#!/bin/bash
set -euo pipefail

# ===========================================
# MongoDB Installation Script (Auto-Latest)
# Supports: Ubuntu 20.04 (Focal), 22.04 (Jammy), 24.04 (Noble)
# Installs the latest stable on-premises release (8.0-series)
# ===========================================

# Detect the latest on-prem MongoDB version
MONGO_VERSION="8.0"
# Detect Ubuntu codename dynamically
UBUNTU_CODENAME=$(lsb_release -sc)

# Define GPG keyring and sources list paths
KEYRING_PATH="/usr/share/keyrings/mongodb-server-${MONGO_VERSION}.gpg"
LIST_PATH="/etc/apt/sources.list.d/mongodb-org-${MONGO_VERSION}.list"

echo "[INFO] Updating package list and installing prerequisites..."
sudo apt-get update -y
sudo apt-get install -y gnupg curl ca-certificates lsb-release

echo "[INFO] Adding MongoDB GPG key..."
curl -fsSL "https://www.mongodb.org/static/pgp/server-${MONGO_VERSION}.asc" | \
    sudo gpg --dearmor -o "${KEYRING_PATH}"

echo "[INFO] Setting up MongoDB repository for Ubuntu ${UBUNTU_CODENAME}..."
echo "deb [ arch=amd64,arm64 signed-by=${KEYRING_PATH} ] https://repo.mongodb.org/apt/ubuntu ${UBUNTU_CODENAME}/mongodb-org/${MONGO_VERSION} multiverse" | \
    sudo tee "${LIST_PATH}"

echo "[INFO] Updating package list again..."
sudo apt-get update -y

echo "[INFO] Installing mongodb-org (latest patch of ${MONGO_VERSION} series)..."
sudo apt-get install -y mongodb-org

echo "[INFO] Setting proper permissions for data directory..."
# Using default path; adjust if customized in mongod.conf
sudo mkdir -p /var/lib/mongodb
sudo chown -R mongodb:mongodb /var/lib/mongodb
sudo mkdir -p /var/log/mongodb
sudo chown -R mongodb:mongodb /var/log/mongodb

echo "[INFO] Enabling and starting MongoDB service..."
sudo systemctl daemon-reload
sudo systemctl enable --now mongod

echo "[INFO] MongoDB service status:"
sudo systemctl status mongod --no-pager

echo "[INFO] Installed MongoDB version:"
mongod --version
