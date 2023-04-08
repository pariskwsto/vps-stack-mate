# vps-stack-mate

> Easy VPS deployment tool with Nginx Reverse Proxy, SSL, and Docker Compose services

This repository includes all the necessary files and configurations for a quick and easy VPS stack deployment. With just a few commands, you'll have your server up and running in minutes, saving you valuable time to focus on developing your web applications and services.

## Contents

- [Getting Started](#getting-started)
  - [Install and Use](#install-and-use)
  - [Make scripts executable (if needed)](#make-scripts-executable-if-needed)
  - [Generate the configuration files](#generate-the-configuration-files)
  - [Deploy the stack](#deploy-the-stack)
- [API](#api)
- [License](#license)
- [Support](#support)

## Getting Started

### 1. Install and Use

<small>Start by cloning this repository</small>

```sh
# via HTTPS
$ git clone https://github.com/pariskwsto/vps-stack-mate.git
```

<small>then</small>

```sh
# cd into project root
$ cd vps-stack-mate
```

### 2. Make scripts executable (if needed)

```sh
# make `mate.sh` and `scripts/` executable
$ chmod +x mate.sh && chmod -R +x scripts/
```

### 3. Generate the configuration files

<small>Type the command below to generate the `.env` and `domains.json` files.</small>

```sh
$ ./mate.sh generate-all-config-files

# `.env` needs your email for the SSL certificates
# update the new `domains.json` file with your domains list
```

<small>Example of `domains.json` file:</small>

```domains.json
["example.com", "subdomain.example.com"]
```

### 4. Deploy the stack

```sh
# Type the command below to deploy the stack
$ ./mate.sh deploy-stack
```

## API

| Command                                  | Description                                                                                           |
| ---------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `$ ./mate.sh generate-env-file`          | Generate the `.env` file with SSL email configuration.                                                |
| `$ ./mate.sh generate-domains-file`      | Generate the `domains.json` file with the list of domains and subdomains to be used in the VPS stack. |
| `$ ./mate.sh generate-all-config-files`  | Generate both `.env` and `domains.json` files at once.                                                |
| `$ ./mate.sh deploy-domains`             | Setup domains and subdomains for the VPS stack using Nginx reverse proxy.                             |
| `$ ./mate.sh deploy-services`            | Deploy the Docker Compose services for the VPS stack.                                                 |
| `$ ./mate.sh deploy-stack`               | Deploy both domains and services for the VPS stack.                                                   |
| `$ ./mate.sh clean-stack`                | Remove all config files                                                                               |
| `$ ./mate.sh -h` or `$ ./mate.sh --help` | Display the help message.                                                                             |

## License

This repository is licensed under the [MIT License](https://opensource.org/licenses/MIT).

## Support

For support and questions, please open an issue in the repository or contact the designer directly.

## Useful Links

- [Adding colors to Bash scripts](https://dev.to/ifenna__/adding-colors-to-bash-scripts-48g4/)
