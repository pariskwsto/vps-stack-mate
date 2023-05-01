# vps-stack-mate

> Easy VPS deployment tool with Nginx Reverse Proxy, SSL, and Docker Compose services

## Contents

- [Getting Started](#getting-started)
  - [Install and Use](#install-and-use)
  - [Make scripts executable (if needed)](#make-scripts-executable-if-needed)
  - [Generate the configuration files](#generate-the-configuration-files)
  - [Deploy the stack](#deploy-the-stack)
  - [Continue with your setup](#continue-with-your-setup)
- [API](#api)
- [License](#license)
- [Support](#support)
- [Useful Links](#useful-links)

This repository includes all the necessary files and configurations for a quick and easy VPS stack deployment. With just a few commands, you'll have your server up and running in minutes, saving you valuable time to focus on developing your web applications and services.

## Getting Started

### Install and Use

Start by cloning this repository in your VPS

```sh
# via HTTPS
git clone https://github.com/pariskwsto/vps-stack-mate.git
```

then

```sh
# cd into project root
cd vps-stack-mate
```

### Make scripts executable (if needed)

```sh
# make `mate.sh` and `scripts/` executable
chmod +x mate.sh && chmod -R +x scripts/
```

### Generate the configuration files

Type the command below to generate the `.env` and `domains.json` files.

```sh
./mate.sh generate-config-files
```

```sh
# The generation of the `.env` file will ask for your email
# It will be used for SSL certificates

# After the script execution you need to update
# the new `domains.json` file with your domains list

# edit the file
$ nano domains.json

# paste your domains and subdomains list
# ["example.com", "subdomain.example.com"]

# ctrl + x to save and exit
```

### Deploy the stack

```sh
# Type the command below to deploy the stack
./mate.sh deploy-stack
```

### Continue with your setup

After some domains addition and setup you can continue with the following steps:

- add the services you need in `docker-compose.yml` file

```docker-compose.yml
version: "3.9"

services:
  nginx:
    ...
    ...
  my-service:
    container_name: my-service
    image: hello-world
    ports:
      - "3000:3000"
```

- add the nginx configuration files you need in `nginx/conf` directory using the following naming convention<br/>
  domain: `example.com` => conf file: `example.com.conf`<br/>
  and a `proxy_pass` with the name of the service (e.g. my-service) you want to serve <br/>

```example.com.conf
server {
  listen 80;
  server_name example.com;
  server_tokens off;

  location /.well-known/acme-challenge/ {
      root /var/www/certbot;
  }

  location / {
      return 301 https://$host$request_uri;
  }
}

server {
  listen 443 ssl;
  server_name example.com;
  server_tokens off;

  ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
  include /etc/letsencrypt/options-ssl-nginx.conf;
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

  location / {
    proxy_pass http://my-service/;
  }
}
```

- redeploy the stack

```sh
./mate.sh reload-stack
```

## API

| Command                                | Description                                                              |
| -------------------------------------- | ------------------------------------------------------------------------ |
| `./mate.sh generate-env-file`          | Generate the `.env` file with SSL email configuration.                   |
| `./mate.sh generate-domains-file`      | Generate the `domains.json` file with the domains and subdomains list.   |
| `./mate.sh generate-config-files`      | Generate all config files at once.                                       |
| `./mate.sh deploy-domains`             | Setup domains and subdomains (+SSL certificates).                        |
| `./mate.sh deploy-services`            | Deploy the Docker Compose services.                                      |
| `./mate.sh deploy-stack`               | Deploy both domains and services for the VPS stack.                      |
| `./mate.sh reload-domains`             | Reload all domains and subdomains nginx conf files.                      |
| `./mate.sh reload-service`             | Reload a service to fix an issue or get the latest version of the image. |
| `./mate.sh reload-stack`               | Redeploy all services and reload all domains.                            |
| `./mate.sh clean-stack`                | Remove all the config files.                                             |
| `./mate.sh -h` or `$ ./mate.sh --help` | Display the help message.                                                |

## License

This repository is licensed under the [MIT License](https://opensource.org/licenses/MIT).

## Support

For support and questions, please open an issue in the repository or contact the designer directly.

## Useful Links

- [Adding colors to Bash scripts](https://dev.to/ifenna__/adding-colors-to-bash-scripts-48g4/)
