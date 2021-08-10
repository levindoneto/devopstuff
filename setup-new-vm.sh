git config --global user.name "Levindo Gabriel Taschetto Neto"
git config --global user.email "levindogtn@gmail.com"

sudo apt update
sudo apt install nodejs -y
sudo apt install npm -y

npm install --global yarn
npm install pm2 -g

# Site
git clone https://github.com/DawntechInc/dawntech.dev
cd dawntech.dev;

yarn
pm2 start yarn --name dawntechsite -- start;

cd ..;

sudo apt-get install nginx
sudo nano /etc/nginx/sites-available/default
"""
server {
    server_name dawntech.dev;
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
}
"""

# SSL
sudo mkdir /etc/nginx/ssl
sudo chown -R root:root /etc/nginx/ssl
sudo chmod -R 600 /etc/nginx/ssl
sudo openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048

# Certbot
sudo apt-get update
sudo apt-get install software-properties-common
sudo apt-add-repository -r ppa:certbot/certbot
sudo apt-get install python3-certbot-nginx

# Get certificate to each domain
sudo certbot --nginx-server-root /etc/nginx
# Verify certificate on https://www.ssllabs.com/ssltest/analyze.html?d=dawntech.dev&latest
