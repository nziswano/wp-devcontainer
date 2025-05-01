ARG VARIANT=8

FROM mcr.microsoft.com/devcontainers/php:${VARIANT}
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev"

LABEL build.step.base=install_base
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends locales universal-ctags \
  vim fzf bat httpie fd-find tmux \
  fonts-powerline fonts-firacode \
  curl unzip watchman \
  jq yq shellcheck git-extras \
  libicu-dev libzip-dev pkg-config libxml2-dev \
  mariadb-client graphviz python3-full pipx \
  && locale-gen en_US.UTF-8

LABEL build.step.apps=install_apps
RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
  sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
  echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | \
  sudo tee /etc/apt/sources.list.d/ngrok.list && \
  sudo apt update && sudo apt install ngrok

# Install 1Password CLI
RUN curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | sudo tee /etc/apt/sources.list.d/1password.list \
  && sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ && curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
  sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol \
  && sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 \
  && curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg \
  && sudo apt update && sudo apt install 1password-cli

LABEL build.step.php=install_php
RUN docker-php-ext-install mysqli pdo pdo_mysql intl zip bcmath soap

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && sudo chmod +x wp-cli.phar \
  && sudo mv wp-cli.phar /usr/local/bin/wp && wp --info

# Install composer
RUN sudo curl -sSL https://getcomposer.org/installer | php \
  && sudo chmod +x composer.phar \
  && sudo mv composer.phar /usr/local/bin/composer

# Install PHIVE
RUN sudo wget -O phive.phar "https://phar.io/releases/phive.phar" \
  && sudo wget -O phive.phar.asc "https://phar.io/releases/phive.phar.asc" \
  && sudo gpg --keyserver hkps://keys.openpgp.org --recv-keys 0x6AF725270AB81E04D79442549D8A98B29B2D5D79 \
  && sudo gpg --verify phive.phar.asc phive.phar \
  && sudo rm phive.phar.asc \
  && sudo chmod +x phive.phar \
  && sudo mv phive.phar /usr/local/bin/phive && phive version

LABEL build.step.sam=install_sam
RUN curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-arm64.zip" -o "awssam.zip" \
  && unzip awssam.zip -d sam-install \
  && sudo ./sam-install/install \
  && rm awssam.zip && sam --version

# Store vscode extensions between builds
ARG USERNAME=vscode
RUN mkdir -p /home/$USERNAME/.vscode-server/extensions \
  && chown -R $USERNAME /home/$USERNAME/.vscode-server

LABEL build.step.delta=build_delta
ARG DELTA_VERSION=0.18.2
RUN wget https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_arm64.deb \
  && sudo dpkg -i git-delta_${DELTA_VERSION}_arm64.deb \
  && rm git-delta_${DELTA_VERSION}_arm64.deb

RUN sudo apt-get autoremove -y && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*
