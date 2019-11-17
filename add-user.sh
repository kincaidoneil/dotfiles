#!/bin/bash

# Adapted from: https://github.com/jessfraz/dotfiles/blob/master/bin/install.sh

set -e # Exit immediately when a command fails
set -o pipefail # Pipes should also fail immediately

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit
fi

echo "Creating new user..."
echo

# Add user if I don't already exist
id -u kincaid &>/dev/null || adduser kincaid
usermod -aG sudo kincaid

# Copy root user's SSH keys to new user account
rsync --archive --chown=kincaid:kincaid ~/.ssh /home/kincaid

echo "Finished setup."
echo
