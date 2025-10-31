#!/bin/bash

set -e # Exit immediately when a command fails
set -o pipefail # Pipes should also fail immediately

# Ensure script is not run as root
if [ "$EUID" -eq 0 ]; then
  echo "ERROR: Do not run this script as root or with sudo"
  echo "The script will prompt for sudo password when needed"
  exit 1
fi

# Verify user has sudo access
if ! sudo -n true 2>/dev/null; then
  echo "This script requires sudo access. You may be prompted for your password."
  sudo -v || {
    echo "ERROR: Unable to obtain sudo access"
    exit 1
  }
fi

platform=$(uname -s | tr '[:upper:]' '[:lower:]')

# Install Homebrew on both Mac & Linux
echo "Installing Homebrew..."
echo

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
  echo "ERROR: Homebrew installation failed - check output above"
  exit 1
}

if [ "$platform" = linux ] ; then
  echo "Upgrading..."
  echo

  sudo apt update || true
  sudo apt -y dist-upgrade `# Explanation: https://www.techrepublic.com/article/how-to-tell-the-difference-between-apt-get-upgrade-apt-get-dist-upgrade-and-do-release-upgrade/`

  echo "Installing system utilities..."
  echo

  sudo apt install -y \
    build-essential \
    cmake \
    coreutils \
    curl \
    docker.io `# Maintained by Debian. More info: https://stackoverflow.com/questions/45023363/what-is-docker-io-in-relation-to-docker-ce-and-docker-ee/57678382#57678382` \
    eza `# Replacement for ls` \
    git \
    gnupg2 \
    libssl-dev \
    ssh \
    sudo \
    unzip \
    wget \
    zsh

  echo "Configuring start-up services..."
  echo

  # Fix Docker permissions issue: https://superuser.com/questions/835696/how-solve-permission-problems-for-docker-in-ubuntu
  sudo gpasswd -a $USER docker

  sudo systemctl start docker
  sudo systemctl enable docker

  # Increase file watcher limit to maximum for VS Code: https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc
  sudo sh -c 'echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf'

  # Set default shell to ZSH on Linux
  sudo chsh -s /bin/zsh $USER
fi

if [ "$platform" = darwin ] ; then
  # Source Brew in this shell so brew command is available
  eval "$(/opt/homebrew/bin/brew shellenv)"

  echo "Installing Homebrew packages..."
  echo

  brew install \
    cmake \
    coreutils \
    curl \
    eza \
    gh `# GitHub CLI` \
    git \
    make \
    mkcert `# Tool to sign local certs for development` \
    ngrok \
    openssl `# Updated version of OpenSSL` \
    unzip \
    wget \
    zsh
fi

echo "Installing Rust..."
echo

# Install Rustup (Rust version management tool) which should auto install Rust & Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Only clone dotfiles after installing Git (that way, Git isn't a dependency of this script)
if [ ! -d "$HOME/dotfiles" ]; then
  git clone https://github.com/kincaidoneil/dotfiles "$HOME/dotfiles"
fi

echo "Installing Node.js..."
echo

# Install LTS and latest versions of Node (-y accepts confirm prompt, -n prevents modifying .zshrc, which already references n)
curl -L https://bit.ly/n-install | bash -s -- -y -n lts latest

# Add Node & npm to path in this context
# (.bashrc can only be re-sourced from an interactive shell, but not from a script)
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

echo "Installing Bun..."
echo

curl -fsSL https://bun.sh/install | bash

echo "Installing pkgx..."
echo

curl -Ssf https://pkgx.sh | sh

echo "Installing Claude Code..."
echo

curl -fsSL https://claude.ai/install.sh | bash

npm i -g \
  corepack `# Support for other package managers via npm` \
  pure-prompt \
  trash-cli

# Enable corepack to manage pnpm and yarn
corepack enable

# Clean up existing dotfiles *only*
rm -f ~/.zshrc ~/.gitconfig

# If dotfiles exists in home directory, use that; otherwise, use enclosing folder of the current script
if [ -d "$HOME/dotfiles" ]; then
  dotfiles_dir="$HOME/dotfiles"
else
  dotfiles_dir=$(cd "$(dirname "$0")" && pwd)
fi

ln -sf "$dotfiles_dir/.zshrc" ~/.zshrc
ln -sf "$dotfiles_dir/.gitconfig-$platform" ~/.gitconfig

echo "Installing ZSH..."
echo

# Install zi (Zsh plugin manager, Antibody got deprecated and doesn't support M1)
sh -c "$(curl -fsSL get.zshell.dev)" -- -i skip -b main

echo "Completed installation."
echo
