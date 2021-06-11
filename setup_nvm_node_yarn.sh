sudo apt-get update;
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash;
export NVM_DIR="$HOME/.nvm";
exec bash;
nvm --version;

nvm install node;
nvm install 12.116.3;
nvm ls;

# Install PM2 and YARN
npm install --global yarn;
npm install pm2 -g;

pm2 start yarn --name <APP_TO_INIT> -- start;
