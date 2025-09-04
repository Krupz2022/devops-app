#!/usr/bin/env bash
set -euo pipefail

NODE_MAJOR="${NODE_MAJOR:-20}"   # Node.js version (20 LTS default)


export DEBIAN_FRONTEND=noninteractive

# --- install Node.js (from NodeSource, not Ubuntu repo) ---
echo "Installing prerequisites"
sudo apt-get update -y
sudo apt-get install -y curl ca-certificates gnupg

if ! command -v node >/dev/null 2>&1 || ! node -v | grep -qE "v${NODE_MAJOR}\."; then
  echo "Installing Node.js ${NODE_MAJOR}.x"
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg
  echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" \
    > /etc/apt/sources.list.d/nodesource.list
  sudo apt-get update -y
  sudo apt-get install -y nodejs
else
  echo "Node.js already installed: $(node -v)"
fi

# --- install PM2 ---
if ! command -v pm2 >/dev/null 2>&1; then
  echo "Installing PM2 globally"
  sudo npm install -g pm2
else
  echo "PM2 already installed: $(pm2 -v)"
fi


