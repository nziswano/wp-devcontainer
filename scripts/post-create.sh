#!/usr/bin/env zsh
set -xe
nvm install --lts
npm install -g typescript prettier prettier aws-cdk
npm cache clean
git config --global pull.rebase true
git config --global --add safe.directory /workspace
git config --global user.name "Johan Martin"
git config --global user.email "jnm+johanmartindev@catenare.com"
git config --global gpg.format ssh && git config --global user.signingkey "$SSH_SIGNING_KEY"
git config --global commit.gpgsign true
if git config --global gpg.ssh.program; then
  echo "Unsetting gpg.ssh.program"
  git config --global --unset gpg.ssh.program
fi
