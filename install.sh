#!/bin/bash

# Adapted from: https://github.com/jessfraz/dotfiles/blob/master/bin/install.sh

set -e # Exit immediately when a command fails
set -o pipefail # Pipes should also fail immediately

echo "Copying fresh dotfiles..."
echo

# TODO Error if existing dotfiles exist? Require --force CLI option?

rm -rf \
  dotfiles \
  n \
  .cargo \
  .rustup \
  .npm \
  .zshrc \
  .gitconfig

git clone https://github.com/kincaidoneil/dotfiles
cd dotfiles

# Create symbolic links for dotfiles
# Remember: the source path (1st arg) is *relative* to the link's path (2nd arg)!
# https://unix.stackexchange.com/questions/141436/too-many-levels-of-symbolic-links
ln -s dotfiles/.zshrc $HOME/.zshrc
ln -s dotfiles/.gitconfig $HOME/.gitconfig

# Upgrading sometimes prompts to select a new version of /boot/grub/menu.lst,
# but my terminal cannot select an option. Override and auto select the default
export DEBIAN_FRONTEND=noninteractive

echo "Upgrading..."
echo

sudo apt update || true
sudo apt -y upgrade

echo "Installing system utilities..."
echo

sudo apt install -y \
  build-essential \
  cmake \
  coreutils \
  curl \
  git \
  gnupg2 \
  libssl-dev \
  ssh \
  sudo \
  wget \
  zsh

echo "Installing Node.js..."
echo

# Install LTS and latest versions of Node
curl -L https://git.io/n-install | bash -s -- -y lts latest

# Add Node & npm to path in this context
# (.bashrc can only be re-sourced from an interactive shell, but not from a script)
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

npm i -g \
  pure-prompt \
  trash-cli

echo "Installing Rust..."
echo

# Install Rustup (Rust version management tool) which should auto install Rust & Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Source Cargo in this context
source $HOME/.cargo/env

# Install Exa, replacement for `ls`
# Install "cargo add" command for Cargo.toml
# (when available, may want to switch to apt version)
cargo install \
  exa \
  cargo-edit

# TODO Install Docker and docker-compose

# TODO Setup SSH and GPG agent forwarding (?)

# TODO Add GPG public key

echo "Installing ZSH..."
echo

# Install Antibody
curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin

# Set default shell to ZSH
sudo chsh -s /bin/zsh kincaid

echo "Installing Yarn..."
echo

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt install --no-install-recommends yarn

echo "Completed installation."
echo
