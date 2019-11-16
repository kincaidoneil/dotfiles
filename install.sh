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

id -u kincaid &>/dev/null || adduser kincaid # Add user if I don't exist
usermod -aG sudo kincaid
HOME=/home/kincaid
cd $HOME

echo "Copying dotfiles..."
echo

rm -rf dotfiles
git clone https://github.com/kincaidoneil/dotfiles
cd dotfiles
git checkout ko-linux-refresh

ln -sf .ssh $HOME/.ssh
ln -sf .zshrc $HOME/.zshrc
ln -sf .gitconfig $HOME/.gitconfig

echo "Upgrading..."
echo

apt-get update || true
apt-get -y upgrade

echo "Installing system utilities..."
echo

apt install -y \
  build-essential \
  core-utils \
  curl \
  git \
  gnupg2 \
  ssh \
  wget \
  zsh \
  zsh-antigen

echo "Installing Node.js..."
echo

# Install LTS and latest versions of Node
curl -L https://git.io/n-install | bash -s -- -y lts latest

npm i -g \
  pure-prompt \ # Prompt for ZSH
  trash-cli

echo "Setting up ZSH..."
echo

# Reinitialize shell to finish setup
# (On Ubuntu/Debian, interactive mode is required to source .bashrc: https://github.com/mklement0/n-install#installation-from-github)
set -i
. $HOME/.bashrc
set +i

# Set default shell to ZSH
chsh -s /bin/zsh

echo "Installing Rust..."
echo

# Install Rustup (Rust version management tool) which should auto install Rust & Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Exa, replacement for `ls`
# (when available, may want to switch to apt version)
cargo install exa

# TODO Install Docker and docker-compose

# TODO Setup SSH and GPG agent forwarding (?)

# TODO Add GPG public key

# Spawn new zsh shell
zsh
