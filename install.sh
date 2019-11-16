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

id -u kincaid &>/dev/null || adduser kincaid # Add user if I don't already exist
usermod -aG sudo kincaid
HOME=/home/kincaid
cd $HOME

echo "Copying fresh dotfiles..."
echo

# TODO Error if existing dotfiles exist? Require --force CLI option?

rm -rf \
  dotfiles \
  n \
  .ssh \
  .zshrc \
  .gitconfig

git clone https://github.com/kincaidoneil/dotfiles
cd dotfiles
git checkout ko-linux-refresh

# Create symbolic links for dotfiles
# Remember: the source path (1st arg) is *relative* to the link's path (2nd arg)!
# https://unix.stackexchange.com/questions/141436/too-many-levels-of-symbolic-links
ln -s dotfiles/.ssh $HOME/.ssh
ln -s dotfiles/.zshrc $HOME/.zshrc
ln -s dotfiles/.gitconfig $HOME/.gitconfig

echo "Upgrading..."
echo

apt-get update || true
apt-get -y upgrade

echo "Installing system utilities..."
echo

apt install -y \
  build-essential \
  coreutils \
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

# TODO remove?
# Reinitialize shell to finish setup
# (On Ubuntu/Debian, interactive mode is required to source .bashrc: https://github.com/mklement0/n-install#installation-from-github)
# set -i
# . $HOME/.bashrc
# set +i

npm i -g \
  pure-prompt \ # Prompt for ZSH
  trash-cli

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

echo "Setting up ZSH..."
echo

# Set default shell to ZSH
chsh -s /bin/zsh

# Spawn new zsh shell
zsh
