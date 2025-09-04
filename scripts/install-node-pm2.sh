#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${PM2_NAME:-devops-app}"
ENTRY="${ENTRY:-server.js}"

cd ../

# --- install project dependencies ---
say "Installing npm dependencies"
if [ -f package-lock.json ]; then
  npm ci
else
  npm install
fi

# --- run with PM2 ---
say "Starting app with PM2: ${APP_NAME}"
pm2 delete "${APP_NAME}" || true
pm2 start "${ENTRY}" --name "${APP_NAME}" --update-env --time
pm2 save

say "Done! PM2 apps:"
pm2 ls