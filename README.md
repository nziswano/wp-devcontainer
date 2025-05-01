# WordPress Development Container

- Use as part of php/wordpress developement

## To Use

1. Make a new developer folder `mkdir wp-dev`.
1. Change into folder `cd wp-dev`
1. Checkout this repo into the folder with the `.devcontainer` as the name.

- `git clone git@github.com:johanmartindev/wp-devcontainer.git .devcontainer`
- Change into the folder `cd .devcontainer`
- Copy **example.env** to **devcontainer.env**
- Fill in the missing values in **.env**
- Change into the parent folder `cd ..`
- Clone the Wordpress repo into this folder.
  - `git clone git@github.com:johanmartindev/wordpress-development.git`

1. Open vscode. `code .` or via menu in vs code.
1. Start vscode devcontainer

## Configure docker container

- [Docker Hub PHP Image](https://hub.docker.com/_/php/)
- [Docker PHP Extension Installer](https://github.com/mlocati/docker-php-extension-installer)
