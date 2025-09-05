#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${PM2_NAME:-devops-app}"
ENTRY="${ENTRY:-server.js}"


# --- install project dependencies ---
echo "Installing npm dependencies"
if [ -f package-lock.json ]; then
  sudo npm ci
else
  sudo npm install
fi

# --- run with PM2 ---
echo "Starting app with PM2: ${APP_NAME}"
sudo pm2 delete "${APP_NAME}" || true
sudo pm2 start "${ENTRY}" --name "${APP_NAME}" --update-env --time
sudo pm2 save

echo "Done! PM2 apps:"
sudo pm2 ls