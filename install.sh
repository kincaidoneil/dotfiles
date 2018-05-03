# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install Homebrew packages

# coreutils -- update old versions of Bash things
# trash -- doesn't permanently delete files
# exa -- better ls
# zsh -- way better shell
# z -- quickly navigate to oft-visited directories
brew install trash z git coreutils exa zsh zsh-autosuggestions zsh-syntax-highlighting

# Installs Node.js, NPM and n (package manager) to $HOME/n
# Install LTS and latest versions
curl -L https://git.io/n-install | bash -s -- -y lts latest

# Reinitialize shell
. ~/.bash_profile

# Install my prompt for ZSH
npm i -g pure-prompt

# Install Yarn, but don't install Node again
brew install yarn --without-node

# Copy other config files to home folder
cp .hyper.js ~
cp .zshrc ~

# Set ZSH as the default shell
echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/zsh
