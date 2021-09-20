git config --global user.name "Levindo Gabriel Taschetto Neto"
git config --global user.email "levindogtn@gmail.com"

sudo apt update
sudo apt install nodejs -y
sudo apt install npm -y

npm install --global yarn
npm install pm2 -g

# DOCKER
sudo apt update -y
sudo snap install docker
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Site
git clone https://github.com/DawntechInc/dawntech.dev
cd dawntech.dev;
yarn
pm2 start yarn --name dawntechsite -- start;
cd ..;

# Bots API
git clone https://github.com/DawntechInc/donna-api.dev
cd donna-api/api;
docker-compose build;docker-compose up;
cd ..;

# Reverse Proxy
# sudo unlink /etc/nginx/sites-enabled/default # if needed for unlinking
sudo apt-get install nginx -y
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
}

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
"""
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
sudo apt-get install software-properties-common
sudo apt-add-repository -r ppa:certbot/certbot
sudo apt-get install python3-certbot-nginx

# Get certificate to each domain
sudo certbot --nginx
# Verify certificate on https://www.ssllabs.com/ssltest/analyze.html?d=dawntech.dev&latest

sudo service nginx restart

# SETUP SIMPLE MONGO
git clone https://github.com/dawntech/simplemongo
cd simplemongo
sudo docker-compose up --force-recreate mongodb

# SETUP TELEPRESENCE
curl -s https://packagecloud.io/install/repositories/datawireio/telepresence/script.deb.sh | sudo bash

# Install NVM / Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm list-remote
nvm install v14.17.5
nvm use 14.17.5
node -v

# MongoSH
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
sudo apt-get install gnupg
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
sudo apt-get update
sudo apt-get install -y mongodb-mongosh

# MongoBI
dpkg -l | grep -i openssl
wget https://info-mongodb-com.s3.amazonaws.com/mongodb-bi/v2/mongodb-bi-linux-x86_64-ubuntu2004-v2.14.3.tgz
sudo tar -xvzf mongodb-bi-linux-x86_64-ubuntu2004-v2.14.3.tgz 
sudo install -m755 mongodb-bi-linux-x86_64-ubuntu2004-v2.14.3/bin/mongo* /usr/local/bin/
