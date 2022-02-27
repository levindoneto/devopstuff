git config --global user.name "Levindo Gabriel Taschetto Neto"
git config --global user.email "levindogtn@gmail.com"
git config --global credential.helper store

sudo apt update;
# sudo apt install nodejs -y;
# sudo apt install npm -y;

# Install NVM / Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
# nvm list-remote
nvm install v14.17.5
nvm use 14.17.5
node -v

npm install --global yarn;
npm install pm2 -g;

# DOCKER
sudo apt update -y;
sudo snap install docker;
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose;
sudo chmod +x /usr/local/bin/docker-compose;

# API Client [PORT=3333]
git clone https://github.com/dawntech/api.client.dawntech.dev;
cd api.client.dawntech.dev;
npm install;
node ace build --production --ignore-ts-errors;
cp .env.example .env
cd build;
cp ../.env .
pm2 start npm --name dawntech_apiclient -- start;
cd ../../;

# Bots API [PORT=5090]
git clone https://github.com/dawntech/donna-api.git;
cd donna-api/api;
docker-compose build;docker-compose up -d;
cd ../../;

# Reverse Proxy
# sudo unlink /etc/nginx/sites-enabled/default; # if needed for unlinking
sudo apt-get install nginx -y;
sudo nano /etc/nginx/sites-available/default;
"""
server {
    server_name bots.dawntech.dev;
    location / {
        proxy_pass http://localhost:5090;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

server {
    server_name api.client.dawntech.dev;
    location / {
        proxy_pass http://localhost:3333;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
"""
# Run sudo certbot --nginx after each added entry in NGINX

ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/ # link enable
nginx -t
service nginx reload

sudo service nginx stop

# SSL
sudo mkdir /etc/nginx/ssl
sudo chown -R root:root /etc/nginx/ssl
sudo chmod -R 600 /etc/nginx/ssl
sudo openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048

# Certbot
sudo apt-get update
sudo apt-get install software-properties-common # Y
sudo apt-add-repository -r ppa:certbot/certbot # [ENTER]
sudo apt-get install python3-certbot-nginx -y

fuser -k 80/tcp
service nginx start

# Get certificate to each domain
sudo certbot --nginx
# Verify certificate on https://www.ssllabs.com/ssltest/analyze.html?d=dawntech.dev&latest

sudo service nginx restart