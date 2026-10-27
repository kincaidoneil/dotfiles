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
  echo "ERROR: Homebrew installation failed"
  exit 1
}

if [ "$platform" = linux ] ; then
  echo "Installing system utilities..."
  echo

  sudo apt update || true

  # Skip dist-upgrade in CI (slow, not needed for testing)
  if [ "$CI" != "true" ]; then
    sudo apt -y dist-upgrade
  fi

  sudo apt install -y \
    build-essential \
    cmake \
    coreutils \
    curl \
    eza \
    git \
    gnupg2 \
    libssl-dev \
    ssh \
    sudo \
    unzip \
    wget \
    zsh

  # Skip Docker setup in CI (conflicts with pre-installed packages)
  if [ "$CI" != "true" ]; then
    sudo apt install -y docker.io
    sudo gpasswd -a $USER docker
    sudo systemctl start docker
    sudo systemctl enable docker
  fi

  # Increase file watcher limit to maximum for VS Code
  sudo sh -c 'echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf'

  # Set default shell to ZSH on Linux
  sudo chsh -s /bin/zsh $USER
fi

if [ "$platform" = darwin ] ; then
  # Install Xcode command line tools
  if [ "$CI" != "true" ]; then
    xcode-select --install
  fi

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

echo "Cloning dotfiles..."
echo

# Only clone dotfiles after installing Git (that way, Git isn't a dependency of this script)
if [ ! -d "$HOME/dotfiles" ]; then
  git clone https://github.com/kincaidoneil/dotfiles "$HOME/dotfiles"
fi

# If dotfiles exists in home directory, use that. Otherwise, use enclosing folder of the current script.
if [ -d "$HOME/dotfiles" ]; then
  dotfiles_dir="$HOME/dotfiles"
else
  dotfiles_dir=$(cd "$(dirname "$0")" && pwd)
fi

# Clean up existing dotfiles *only*
rm -f ~/.zshrc ~/.gitconfig

echo "Installing Rust..."
echo

# Install Rustup (Rust version management tool) which should auto install Rust & Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

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

echo "Installing Codex..."
echo

curl -fsSL https://chatgpt.com/codex/install.sh | sh

echo "Installing global npm packages..."
echo

npm i -g \
  agent-browser `# Browser automation CLI the agent-browser skill drives` \
  cf `# Cloudflare CLI` \
  corepack `# Support for other package managers via npm` \
  portless `# Serves local dev at named .localhost URLs instead of ports` \
  pure-prompt \
  trash-cli

# Enable corepack to manage pnpm and yarn
corepack enable

# The CLI ships without a browser. Skipped in CI, where nothing drives it and the
# Chromium download costs more than the coverage is worth.
if [ "$CI" != "true" ]; then
  agent-browser install
fi

echo "Setting up symlinks..."
echo

mkdir -p ~/.claude ~/.agents ~/.codex ~/.config/git

# Tracked outside .claude/ on purpose. This file becomes ~/.claude/settings.json,
# so if it also sat at .claude/settings.json it would double as this repo's project
# settings, and every plugin enabled for the user would also install at project scope.
ln -sf "$dotfiles_dir/claude-settings.json" ~/.claude/settings.json

# AGENTS.md is the single source of truth. Claude Code reads ~/.claude/CLAUDE.md,
# Codex and other agents read ~/.codex/AGENTS.md; both point at the same file.
ln -sf "$dotfiles_dir/AGENTS.md" ~/.claude/CLAUDE.md
ln -sf "$dotfiles_dir/AGENTS.md" ~/.codex/AGENTS.md

# The skills CLI owns .agents/skills and .claude/skills, so both are gitignored.
# Skills we maintain ourselves are tracked in skills/ and linked in beside them.
mkdir -p "$dotfiles_dir/.agents/skills" "$dotfiles_dir/.claude/skills"

for skill in "$dotfiles_dir"/skills/*/; do
  [ -d "$skill" ] || continue # An empty skills/ leaves the glob unexpanded
  # A symlink here points into .agents/skills already. Linking it back would
  # nest a link inside the skills CLI's real directory.
  [ -L "${skill%/}" ] && continue
  skill_name=$(basename "$skill")
  ln -sfn "${skill%/}" "$dotfiles_dir/.agents/skills/$skill_name"
  ln -sfn "../../.agents/skills/$skill_name" "$dotfiles_dir/.claude/skills/$skill_name"
done

# Replace skills dirs if they exist as real directories from a prior run —
# otherwise BSD ln drops the link inside them instead of overwriting.
# Scoped to these two paths only; other files in ~/.claude are left untouched.
for skills_link in ~/.claude/skills ~/.agents/skills; do
  if [ -e "$skills_link" ] && [ ! -L "$skills_link" ]; then
    rm -rf "$skills_link"
  fi
done

ln -sfn "$dotfiles_dir/.claude/skills" ~/.claude/skills
ln -sfn "$dotfiles_dir/.agents/skills" ~/.agents/skills

ln -sf "$dotfiles_dir/.zshrc" ~/.zshrc
ln -sf "$dotfiles_dir/.gitconfig-$platform" ~/.gitconfig

# Git reads ~/.config/git/ignore for every repo, without any gitconfig entry.
ln -sf "$dotfiles_dir/.gitignore-global" ~/.config/git/ignore

echo "Installing ZSH..."
echo

# Install zi (Zsh plugin manager, Antibody got deprecated and doesn't support M1)
sh -c "$(curl -fsSL get.zshell.dev)" -- -i skip -b main

echo "Installing agent skills..."
echo

pnpm dlx skills experimental_install

echo "Installing Claude Code plugins..."
echo

# settings.json registers the marketplaces and enables these, but enabling a
# plugin never installs it, so a fresh machine needs these lines. --scope user is
# already the default; it's explicit so an install can never bind to whatever
# repo this script happens to run from.
claude plugin install braintrust@braintrust-claude-plugin --scope user --yes
claude plugin install mattpocock-skills@mattpocock --scope user --yes

echo "Installing the portless proxy service..."
echo

# The proxy binds 443, so it needs root, and a detached process manager has no
# TTY for a sudo prompt. A startup service is the only form that survives
# `process-compose up -D`. It records the absolute path of the node binary and
# CLI that installed it, and nothing re-points it after an upgrade, so this runs
# on every install rather than only the first.
if [ "$CI" != "true" ]; then
  portless service install
fi

echo "Completed installation."
echo
