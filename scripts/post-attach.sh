#!/bin/bash
set -xe
if git config --global gpg.ssh.program; then
  echo "Unsetting gpg.ssh.program"
  git config --global --unset gpg.ssh.program
  git config --global --add safe.directory /workspace
fi
