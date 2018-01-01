# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install Homebrew packages

# Don't permanently delete files, move them to trash!
brew install trash
# Update old versions of Bash things
brew install coreutils
# Replacement for ls
brew install exa
# A way better shell
brew install zsh

# Installs Node.js, NPM and n (package manager) to $HOME/n
# Install LTS and latest versions
curl -L https://git.io/n-install | bash -s -- -y lts latest

# Reinitialize shell
. ~/.bash_profile

# Install Yarn, but don't install Node again
brew install yarn --without-node
