#!/bin/bash

set -e # Exit immediately when a command fails
set -o pipefail # Pipes should also fail immediately

platform=$(uname -s | tr '[:upper:]' '[:lower:]')

# Only install dependencies if not running in GitHub Codespaces
if [ ! "$CODESPACES" = true ] ; then
  # Install Homebrew on both Mac & Linux

  echo "Installing Homebrew..."
  echo

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

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
      sudo gpasswd -a kincaid docker

      sudo systemctl start docker
      sudo systemctl enable docker

      # Increase file watcher limit to maximum for VS Code: https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc
      sudo sh -c 'echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf'

      # Set default shell to ZSH on Linux
      sudo chsh -s /bin/zsh kincaid
  fi

  if [ "$platform" = darwin ] ; then
    # Source Brew in this shell
    eval "$(/opt/homebrew/bin/brew shellenv)"
  
    echo "Installing Homebrew packages..."
    echo

    brew update # Update Homebrew and all packages

    brew install \
      cmake \
      coreutils \
      curl \
      eza \
      gh `# GitHub CLI` \
      git \
      gpg2 `# gnupg2 is just an alias` \
      make \
      mkcert `# Tool to sign local certs for development` \
      ngrok/ngrok/ngrok \
      openssl `# Updated version of OpenSSL` \
      pinentry-mac \
      unzip \
      wget \
      zsh

    # Configure pinentry-mac so GPG key passwords are stored in macOS keychain
    mkdir -p ~/.gnupg # GnuPG might not be created yet
    echo "pinentry-program /opt/homebrew/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
  fi

  echo "Installing Rust..."
  echo

  # Install Rustup (Rust version management tool) which should auto install Rust & Cargo
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

  # Only clone dotfiles after installing Git (that way, Git isn't a dependency of this script)
  # In some environments, e.g. GitHub Codespaces, the repo will already be cloned
  [ ! -d "$HOME/dotfiles" ] && git clone https://github.com/kincaidoneil/dotfiles

  echo "Installing Node.js..."
  echo

  # Install LTS and latest versions of Node (-y accepts confirm prompt, -n prevents modifying .zshrc, which already references n)
  curl -L https://git.io/n-install | bash -s -- -y -n lts latest

  # Add Node & npm to path in this context
  # (.bashrc can only be re-sourced from an interactive shell, but not from a script)
  export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

  echo "Installing Deno..."
  echo

  curl -fsSL https://deno.land/x/install/install.sh | sh

  echo "Installing Bun..."
  echo

  curl -fsSL https://bun.sh/install | bash

  echo "Installing pkgx..."
  echo

  curl -Ssf https://pkgx.sh | sh
fi

npm i -g \
  pnpm \
  pure-prompt \
  trash-cli \
  yarn

# Clean up existing dotfiles *only*
rm -f ~/.zshrc ~/.gitconfig

# If dotfiles exists in home directory, use that; otherwise, use enclosing folder of the current script
[ -d "$HOME/dotfiles" ] \
  && dotfiles_dir=$HOME/dotfiles \
  || dotfiles_dir=$(dirname "$(readlink -f "$0")")

ln -s $dotfiles_dir/.zshrc ~/.zshrc
ln -s $dotfiles_dir/.gitconfig-$platform ~/.gitconfig

echo "Installing ZSH..."
echo

# Install zi (Zsh plugin manager, Antibody got deprecated and doesn't support M1)
sh -c "$(curl -fsSL https://git.io/get-zi)" -- -i skip

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
