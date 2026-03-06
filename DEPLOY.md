# Deploy Portfolio to VPS (hasibsafi.com) — Step by Step

Uses **systemd** (no PM2). Run all commands on your VPS unless noted.

---

## Step 0: Cleanup (if you have an existing deployment)

```bash
chmod +x /var/www/Portfolio/Personal-Potfolio/deploy/cleanup.sh
/var/www/Portfolio/Personal-Potfolio/deploy/cleanup.sh
```

Or run manually:

```bash
pm2 delete portfolio 2>/dev/null || true
sudo rm -f /etc/nginx/sites-enabled/000-hasibsafi.com /etc/nginx/sites-enabled/hasibsafi.com
sudo rm -f /etc/nginx/sites-available/hasibsafi.com
sudo rm -rf /var/www/Portfolio/Personal-Potfolio
sudo nginx -t && sudo systemctl reload nginx
```

---

## Step 1: Create directory and set ownership

```bash
sudo mkdir -p /var/www/Portfolio/Personal-Potfolio
sudo chown -R hasib:hasib /var/www/Portfolio/Personal-Potfolio
```

---

## Step 2: Clone the project

```bash
cd /var/www/Portfolio
rm -rf Personal-Potfolio
git clone https://github.com/hasibsafi/Personal-Potfolio.git
cd Personal-Potfolio
```

---

## Step 3: Install dependencies and build

```bash
cd /var/www/Portfolio/Personal-Potfolio
npm install
npm run build
```

---

## Step 4: Install systemd service

```bash
sudo cp /var/www/Portfolio/Personal-Potfolio/deploy/portfolio.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable portfolio
sudo systemctl start portfolio
sudo systemctl status portfolio
```

---

## Step 5: Configure Nginx

```bash
sudo cp /var/www/Portfolio/Personal-Potfolio/deploy/nginx.hasibsafi.com.conf /etc/nginx/sites-available/hasibsafi.com
sudo ln -sf /etc/nginx/sites-available/hasibsafi.com /etc/nginx/sites-enabled/000-hasibsafi.com
sudo nginx -t && sudo systemctl reload nginx
```

---

## Step 6: SSL (if not already done)

```bash
sudo certbot certonly --manual --preferred-challenges dns -d hasibsafi.com -d www.hasibsafi.com
# Add TXT record when prompted, wait, then press Enter
```

---

## Step 7: Verify

```bash
sudo ss -tlnp | grep 3005
curl -sI http://127.0.0.1:3005 | head -3
curl -sL https://hasibsafi.com | grep -o "<title>.*</title>"
```

---

## Deploying updates

```bash
cd /var/www/Portfolio/Personal-Potfolio
./deploy/deploy.sh
```

---

## Useful commands

| Command | Description |
|---------|-------------|
| `sudo systemctl status portfolio` | Check service status |
| `sudo systemctl restart portfolio` | Restart app |
| `sudo journalctl -u portfolio -f` | View logs |
| `sudo systemctl stop portfolio` | Stop app |
