#!/bin/bash
set -euo pipefail


# ===========================================
# Node.js Cleanup + Fresh Installation Script
# Removes old Ubuntu repo Node.js & installs
# latest Node.js (via NodeSource)
# ===========================================


# Variables
NODE_VERSION="20"   # LTS version (can set to 22 for Current)


echo "[INFO] Removing old Node.js packages..."
sudo apt-get remove -y nodejs libnode-dev npm || true
sudo apt-get autoremove -y
sudo apt-get purge -y nodejs libnode-dev npm || true


echo "[INFO] Cleaning up apt cache..."
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get update -y


echo "[INFO] Installing prerequisites..."
sudo apt-get install -y curl ca-certificates gnupg lsb-release


echo "[INFO] Adding NodeSource GPG key..."
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
  sudo gpg --dearmor -o /usr/share/keyrings/nodesource.gpg


echo "[INFO] Adding Node.js ${NODE_VERSION}.x repository..."
echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_VERSION}.x nodistro main" \
  | sudo tee /etc/apt/sources.list.d/nodesource.list


echo "[INFO] Updating apt packages..."
sudo apt-get update -y


echo "[INFO] Installing Node.js ${NODE_VERSION}.x and npm..."
sudo apt-get install -y nodejs


echo "[INFO] Verifying installation..."
node -v
npm -v


echo "[INFO] (Optional) Install build tools for native addons..."
sudo apt-get install -y build-essential


echo "[SUCCESS] Node.js ${NODE_VERSION}.x installed cleanly!"
