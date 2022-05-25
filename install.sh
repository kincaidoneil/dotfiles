#!/bin/bash

# Adapted from: https://github.com/jessfraz/dotfiles/blob/master/bin/install.sh

set -e # Exit immediately when a command fails
set -o pipefail # Pipes should also fail immediately

echo "Cleaning up old dotfiles..."
echo

cd ~
rm -rf \
  n \
  .cargo \
  .rustup \
  .npm \
  .zshrc \
  .zi \
  .gitconfig

PLATFORM=$(uname -s | tr '[:upper:]' '[:lower:]')

if [ "$PLATFORM" = linux ] ; then
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
    exa `# Replacement for ls` \
    git \
    gnupg2 \
    libssl-dev \
    pkg-config `# Required by Interledger.rs to build OpenSSL` \
    redis-server \
    ssh \
    sudo \
    unzip \
    wget \
    zsh

    echo "Configuring start-up services..."
    echo

    # Fix Docker permissions issue: https://superuser.com/questions/835696/how-solve-permission-problems-for-docker-in-ubuntu
    sudo gpasswd -a kincaid docker

    sudo systemctl start docker
    sudo systemctl enable docker

    # Setup Redis: https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-20-04
    sudo sed 's/\nsupervised no/\nsupervised systemd/g' /etc/redis/redis.conf
    sudo systemctl restart redis.service

    # Increase file watcher limit to maximum for VS Code: https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc
    sudo sh -c 'echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf'
fi

if [ "$PLATFORM" = darwin ] ; then
  echo "Installing Homebrew..."
  echo

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo "Installing Homebrew packages..."
  echo

  brew update # Update Homebrew and all packages

  brew install \
    cmake \
    coreutils \
    curl \
    exa \
    git \
    gpg2 `# gnupg2 is just an alias` \
    make \
    pinentry-mac \
    unzip \
    wget \
    zsh

  # Install Adoptium distribution of JDK
  brew install --cask temurin

  # Source Brew in this shell
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # Configure pinentry-mac so GPG key passwords are stored in macOS keychain
  mkdir -p ~/.gnupg # GnuPG might not be created yet
  echo "pinentry-program /opt/homebrew/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
fi

# Only clone dotfiles after installing Git --- that way, doesn't make Git a dependency
# In some cases, e.g. GitHub Codespaces, the repo will already be cloned
[ ! -d "dotfiles" ] && git clone https://github.com/kincaidoneil/dotfiles

# Create symbolic links for dotfiles
# Remember: the source path (1st arg) is *relative* to the link's path (2nd arg)!
# https://unix.stackexchange.com/questions/141436/too-many-levels-of-symbolic-links
ln -s dotfiles/.zshrc $HOME/.zshrc
ln -s dotfiles/.gitconfig-$PLATFORM $HOME/.gitconfig

echo "Installing Node.js..."
echo

# Install LTS and latest versions of Node (-y accepts confirm prompt, -n prevents modifying .zshrc, which already references n)
curl -L https://git.io/n-install | bash -s -- -y -n lts latest

# Add Node & npm to path in this context
# (.bashrc can only be re-sourced from an interactive shell, but not from a script)
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

npm i -g \
  pure-prompt \
  trash-cli \
  yarn

echo "Installing Rust..."
echo

# Install Rustup (Rust version management tool) which should auto install Rust & Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

echo "Installing ZSH..."
echo

# Install zi (Zsh plugin manager, Antibody got deprecated and doesn't support M1)
sh -c "$(curl -fsSL https://git.io/get-zi)" -- -i skip

# Set default shell to ZSH
sudo chsh -s /bin/zsh kincaid

if [ "$DIGITAL_OCEAN" = "1" ] ; then
  echo "Installing DigitalOcean metrics..."
  echo

  curl -sSL https://repos.insights.digitalocean.com/install.sh -o /tmp/install.sh
  sudo bash /tmp/install.sh
  /opt/digitalocean/bin/do-agent --version
  trash /tmp/install.sh
fi

echo "Completed installation."
echo
