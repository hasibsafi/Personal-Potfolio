#!/bin/bash
# Run from your local machine to deploy to VPS via rsync
# Usage: ./deploy/deploy-from-local.sh [user@host]
# Example: ./deploy/deploy-from-local.sh hasib@srv1310066

HOST="${1:-hasib@srv1310066}"
REMOTE_DIR="/var/www/Portfolio"
LOCAL_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo ">>> Syncing files to $HOST:$REMOTE_DIR"
rsync -avz --delete \
  --exclude 'node_modules' \
  --exclude '.next' \
  --exclude '.git' \
  --exclude '.env*.local' \
  "$LOCAL_DIR/" "$HOST:$REMOTE_DIR/"

echo ">>> Running deploy on server..."
ssh "$HOST" "cd $REMOTE_DIR && chmod +x deploy/deploy.sh && ./deploy/deploy.sh"

echo ">>> Done! Visit https://hasibsafi.com"
