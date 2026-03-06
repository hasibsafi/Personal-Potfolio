#!/bin/bash
# Deploy script - run on VPS from project directory
set -e

cd /var/www/Portfolio/Personal-Potfolio

if [ -d .git ]; then
  echo ">>> Pulling latest changes..."
  git pull origin main
else
  echo ">>> No git repo - using existing files"
fi

echo ">>> Installing dependencies..."
if [ -f package-lock.json ]; then npm ci; else npm install; fi

echo ">>> Building..."
npm run build

echo ">>> Restarting portfolio service..."
sudo systemctl restart portfolio

echo ">>> Deployment complete!"
