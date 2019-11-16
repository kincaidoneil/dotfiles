#!/bin/bash

# Adapted from: https://github.com/jessfraz/dotfiles/blob/master/bin/install.sh

set -e # Exit immediately when a command fails
set -o pipefail # Pipes should also fail immediately

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit
fi

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
git checkout ko-linux-refresh # TODO Change to master branch

# Create symbolic links for dotfiles
# Remember: the source path (1st arg) is *relative* to the link's path (2nd arg)!
# https://unix.stackexchange.com/questions/141436/too-many-levels-of-symbolic-links
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
  zsh

echo "Installing Node.js..."
echo

# Install LTS and latest versions of Node
curl -L https://git.io/n-install | bash -s -- -y lts latest

. ~/.bashrc # TODO Does this work?

npm i -g \
  pure-prompt \
  trash-cli

echo "Installing Rust..."
echo

# Install Rustup (Rust version management tool) which should auto install Rust & Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

. ~/.bashrc # TODO Does this work?

# Install Exa, replacement for `ls`
# (when available, may want to switch to apt version)
cargo install exa

# TODO Why can't I SSH in as my user?

# TODO Install Docker and docker-compose

# TODO Setup SSH and GPG agent forwarding (?)

# TODO Add GPG public key

echo "Installing ZSH..."
echo

# Install Antigen since apt version doesn't work
mkdir -p ~/.zsh/antigen
curl -L git.io/antigen > ~/.zsh/antigen/antigen.zsh

# Set default shell to ZSH
chsh -s /bin/zsh

# Spawn new zsh shell
zsh
