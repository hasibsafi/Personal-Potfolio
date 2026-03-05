#!/bin/bash
# Deploy script - run this on the VPS from /var/www/Portfolio
set -e

cd /var/www/Portfolio/Personal-Potfolio

if [ -d .git ]; then
  echo ">>> Pulling latest changes..."
  git pull origin main
else
  echo ">>> No git repo - using existing files (upload new files first if needed)"
fi

echo ">>> Installing dependencies..."
if [ -f package-lock.json ]; then npm ci; else npm install; fi

echo ">>> Building..."
npm run build

echo ">>> Restarting PM2..."
pm2 reload ecosystem.config.cjs --update-env

echo ">>> Deployment complete!"
