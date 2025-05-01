#!/usr/bin/env zsh
set -xe
. ${NVM_DIR}/nvm.sh
nvm install --lts --latest-npm --default --save
npm install -g typescript prettier prettier aws-cdk
