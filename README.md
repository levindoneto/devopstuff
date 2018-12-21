# DEVOPSTUFF

Various commands, important tutorials and settings for building and deploying services in a continuous way.

**Infrastructure Provider:** Digital Ocean.

**CI:** GitLab CI.

**Author:** Levindo Gabriel Taschetto Neto.

## Install gitlab runner
https://about.gitlab.com/2016/04/19/how-to-set-up-gitlab-runner-on-digitalocean/

## Add SSH_PRIVATE_KEY
https://docs.gitlab.com/ee/ci/ssh_keys/
SSH_PRIVATE_KEY <- id_rsa in the ci settings variables
```
$ cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
```

## Subdomain redirect to an other ip/port
### Install NGINX for reverse proxying

```
$ sudo apt-get install nginx
$ sudo nano /etc/nginx/sites-available/default
```

Copy (nginx-config/http2)[nginx-config/http2] into it.

```
$ sudo service nginx restart

### Set up HTTPS

```
$ sudo mkdir /etc/nginx/ssl
$ sudo chown -R root:root /etc/nginx/ssl
$ sudo chmod -R 600 /etc/nginx/ssl

$ openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048
```

```
$ sudo service nginx stop
```

#### Get Certbot
```
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-nginx 
```

#### Create certificate for each app 

Options may be found on (ssl)[ssl].
```
sudo certbot --nginx-server-root /etc/nginx
```


### Add SSL certificate

## Problems found on the way

### Unzip not found
```
$ apt-get install unzip
```

### If INFO: 1 key(s) remain to be installed:
https://www.digitalocean.com/community/questions/ssh-copy-id-not-working-permission-denied-publickey

### Assign a Runner to Multiple Projects
https://dzone.com/articles/changing-a-gitlab-runner-from-locked-to-a-project

### Error to restart NGINX

It happened because the apache2 service was running, so:

```
$ sudo /etc/init.d/apache2 stop
```

