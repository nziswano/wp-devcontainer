ARG VARIANT=8

FROM mcr.microsoft.com/devcontainers/php:${VARIANT}
ARG DELTA_VERSION=0.18.2
ARG USERNAME=vscode
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev"

LABEL build.step.base=install_base
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
  bat \
  build-essential \
  ca-certificates \
  curl \
  docker.io \
  fd-find \
  fonts-firacode \
  fonts-liberation \
  fonts-powerline \
  git-extras \
  gnupg2 \
  golang \
  gpg \
  jq \
  libasound2 \
  libatk-bridge2.0-0 \
  libatk1.0-0 \
  libatspi2.0-0 \
  libcairo2 \
  libcups2 \
  libdrm2 \
  libffi-dev \
  libgbm1 \
  libgtk-3-0 \
  libnss3 \
  libpango-1.0-0 \
  libssl-dev \
  libu2f-udev \
  libudev-dev \
  libxcomposite1 \
  libxdamage1 \
  libxfixes3 \
  libxkbcommon0 \
  libxrandr2 \
  libyaml-dev \
  neovim \
  ripgrep \
  shellcheck \
  sqlite3 \
  sudo \
  tmux \
  wget \
  xz-utils \
  zlib1g-dev \
  && locale-gen en_US.UTF-8

LABEL build.step.php=install_php
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends \
  mariadb-client libicu-dev libzip-dev pkg-config libxml2-dev imagemagick \
  libgd-dev libfreetype-dev libpng-dev libjpeg62-turbo-dev ghostscript

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql intl zip bcmath soap sockets exif
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN install-php-extensions imagick solr @composer

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && sudo chmod +x wp-cli.phar \
  && sudo mv wp-cli.phar /usr/local/bin/wp && wp --info

# Install PHIVE
RUN sudo wget -O phive.phar "https://phar.io/releases/phive.phar" \
  && sudo wget -O phive.phar.asc "https://phar.io/releases/phive.phar.asc" \
  && sudo gpg --keyserver hkps://keys.openpgp.org --recv-keys 0x6AF725270AB81E04D79442549D8A98B29B2D5D79 \
  && sudo gpg --verify phive.phar.asc phive.phar \
  && sudo rm phive.phar.asc \
  && sudo chmod +x phive.phar \
  && sudo mv phive.phar /usr/local/bin/phive && phive version

LABEL build.step.apps=install_apps
RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
  sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
  echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | \
  sudo tee /etc/apt/sources.list.d/ngrok.list && \
  sudo apt update && sudo apt install ngrok

LABEL build.step.1password=install_1password
RUN curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | sudo tee /etc/apt/sources.list.d/1password.list \
    && sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ && curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
    sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol \
    && sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 \
    && curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
    sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg \
    && sudo apt-get update && sudo apt-get install -y --no-install-recommends 1password-cli \
    && op --version

LABEL build.step.git-delta=build_delta
RUN set -eux; \
    ARCH=$(dpkg --print-architecture); \
    wget -q https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_${ARCH}.deb -O /tmp/git-delta.deb && \
    sudo dpkg -i /tmp/git-delta.deb && \
    rm /tmp/git-delta.deb || echo "git-delta installation failed, continuing..."

LABEL build.step.git-tools=build_git_tools
RUN set -eux; \
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*') && \
        ARCH=$(dpkg --print-architecture) && \
        case "${ARCH}" in \
            amd64) LAZYGIT_ARCH="x86_64" ;; \
            arm64) LAZYGIT_ARCH="arm64" ;; \
            armhf) LAZYGIT_ARCH="armv6" ;; \
            *) echo "Unsupported architecture for lazygit: ${ARCH}"; exit 1 ;; \
        esac && \
        curl -fsSLo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_linux_${LAZYGIT_ARCH}.tar.gz" && \
    tar -xf /tmp/lazygit.tar.gz -C /tmp lazygit && \
    sudo install /tmp/lazygit /usr/local/bin/ && \
    rm -rf /tmp/lazygit.tar.gz /tmp/lazygit

LABEL build.step.misenplace=install_misenplace
RUN su vscode -c "curl https://mise.jdx.dev/install.sh | sh" 2>&1

LABEL build.step.misenplace_node=setup_node
RUN mkdir -p /home/$USERNAME/vscode \
    && printf "typescript\nprettier\n@openai/codex\n@github/copilot\n@google/gemini-cli\n" > /home/$USERNAME/.default-npm-packages
RUN chown $USERNAME:$USERNAME /home/$USERNAME/.default-npm-packages
RUN su $USERNAME -c "eval \"\$(/home/$USERNAME/.local/bin/mise activate bash)\" && /home/$USERNAME/.local/bin/mise use -g fnox" 2>&1

LABEL build.step.delta=vscode_extensions
RUN mkdir -p /home/$USERNAME/.vscode-server/extensions \
  && chown -R $USERNAME /home/$USERNAME/.vscode-server

LABEL build.step.cleanup=build_cleanup
RUN sudo apt-get autoremove -y && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*
