# Strapi pro docker

## About The Project

The goal is to set up fastly a local [Strapi](https://strapi.io/) project with docker environment for professional uses.

### Requirements

* [Yarn](https://yarnpkg.com/getting-started/install)
* [NVM](https://github.com/nvm-sh/nvm) installation is strongly recommanded if you want to make front integration.

### Built With

* [Official Node Docker Image](https://hub.docker.com/_/node)
* [Official MySQL Docker Image](https://hub.docker.com/_/mysql)
* [Official adminer Docker Image](https://hub.docker.com/_/adminer)
* [Official traefik Docker Image](https://hub.docker.com/_/traefik)

## Getting Started

### Installation

   ```sh
   git clone git@github.com:splitant/strapi-pro-docker.git
   cd strapi-pro-docker
   make create-setup <project> <repo-git>
   
   # Configure your .env file
   # Please change : APP_KEYS, API_TOKEN_SALT, ADMIN_JWT_SECRET, JWT_SECRET
   # You can generate theses with the command line : 
   # openssl rand -base64 16

   make up
   make shell # Connect to strapi container.
   strapi dev # Launch develop mode.
   ```

### New project

   ```sh
   git clone git@github.com:splitant/strapi-pro-docker.git
   cd strapi-pro-docker
   make create-init <project>

   # Configure your .env file
   # Please change : APP_KEYS, API_TOKEN_SALT, ADMIN_JWT_SECRET, JWT_SECRET
   # You can generate theses with the command line : 
   # openssl rand -base64 16

   make init
   make shell # Connect to strapi container.
   strapi dev # Launch develop mode.
   ```

### Start containers

```bash
make start
make shell # Connect to strapi container.
strapi dev # Launch develop mode.
```

### Strapi (backend)

Install packages :
```bash
make strapi-install
```

Build Strapi app :
```bash
make strapi-build
```

Launch development mode :
```bash
make strapi-dev
```

Access to container :
```bash
make shell
```

### Extra

List MakeFile commands :
```bash
make help
```

Tools setted up by default in strapi container :
- `vim`
- `unzip`
- `wget`

## Helpfull strapi plugins

* [Config Sync](https://market.strapi.io/plugins/strapi-plugin-config-sync)
* [CKEditor 5](https://market.strapi.io/plugins/@_sh-strapi-plugin-ckeditor)
* [Migrations](https://market.strapi.io/plugins/strapi-plugin-migrations)
* [Navigation](https://market.strapi.io/plugins/strapi-plugin-navigation)
* [Preview Button](https://market.strapi.io/plugins/strapi-plugin-preview-button)
* [Import Export Entries](https://market.strapi.io/plugins/strapi-plugin-import-export-entries)
* [Sitemap](https://market.strapi.io/plugins/strapi-plugin-sitemap)
* [Slugify](https://market.strapi.io/plugins/strapi-plugin-slugify)
* [URL alias](https://market.strapi.io/plugins/@strapi-community-strapi-plugin-url-alias)
