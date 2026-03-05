# Deploying to VPS (hasibsafi.com)

## Prerequisites on VPS

- Node.js 18+ and npm
- PM2: `npm install -g pm2`
- Nginx
- Git (if deploying via git)

---

## One-time setup

### 1. Create project directory and set ownership

```bash
sudo mkdir -p /var/www/Portfolio
sudo chown -R hasib:hasib /var/www/Portfolio
```

### 2. Deploy your code

**Option A: Git clone**

```bash
cd /var/www
git clone <your-repo-url> Portfolio
cd Portfolio
```

**Option B: Upload files**

Upload the full project (excluding `node_modules` and `.next`) to `/var/www/Portfolio` via rsync, SFTP, or your preferred method.

### 3. Install dependencies and build

```bash
cd /var/www/Portfolio
npm ci
npm run build
```

### 4. Start with PM2

```bash
pm2 start ecosystem.config.cjs
pm2 save
pm2 startup   # Run the command it outputs to enable startup on boot
```

### 5. Configure Nginx

```bash
sudo cp deploy/nginx.hasibsafi.com.conf /etc/nginx/sites-available/hasibsafi.com
sudo ln -sf /etc/nginx/sites-available/hasibsafi.com /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

### 6. SSL with Let's Encrypt (recommended)

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d hasibsafi.com -d www.hasibsafi.com
```

---

## Deploying updates

After pushing changes or uploading new files:

```bash
cd /var/www/Portfolio
chmod +x deploy/deploy.sh
./deploy/deploy.sh
```

Or manually:

```bash
cd /var/www/Portfolio
git pull origin main   # if using git
npm ci
npm run build
pm2 reload ecosystem.config.cjs --update-env
```

---

## Useful commands

| Command | Description |
|---------|-------------|
| `pm2 status` | Check app status |
| `pm2 logs portfolio` | View logs |
| `pm2 restart portfolio` | Restart app |
