#!/bin/bash
# Run on VPS to remove portfolio app and prepare for fresh deploy
set -e

echo ">>> Stopping and removing PM2 portfolio process..."
pm2 delete portfolio 2>/dev/null || true
pm2 save 2>/dev/null || true

echo ">>> Stopping portfolio systemd service (if exists)..."
sudo systemctl stop portfolio 2>/dev/null || true
sudo systemctl disable portfolio 2>/dev/null || true

echo ">>> Removing Nginx config for hasibsafi.com..."
sudo rm -f /etc/nginx/sites-enabled/000-hasibsafi.com
sudo rm -f /etc/nginx/sites-enabled/hasibsafi.com
sudo rm -f /etc/nginx/sites-available/hasibsafi.com
sudo nginx -t && sudo systemctl reload nginx

echo ">>> Removing duplicate files from parent Portfolio folder..."
cd /var/www/Portfolio
sudo rm -rf app components hooks lib public styles deploy 2>/dev/null || true
sudo rm -f package.json package-lock.json pnpm-lock.yaml 2>/dev/null || true
sudo rm -f next.config.mjs tsconfig.json tailwind.config.ts postcss.config.mjs 2>/dev/null || true
sudo rm -f components.json next-env.d.ts .gitignore DEPLOY.md ecosystem.config.cjs 2>/dev/null || true

echo ">>> Removing project directory..."
sudo rm -rf /var/www/Portfolio/Personal-Potfolio

echo ">>> Cleanup complete. Ready for fresh deploy."
