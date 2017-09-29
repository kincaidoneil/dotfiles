# .zshrc
# autoload -U promptinit; promptinit
# prompt pure

# source /usr/local/share/antigen/antigen.zsh

# Load the oh-my-zsh's library.
# antigen use oh-my-zsh

# antigen theme denysdovhan/spaceship-zsh-theme spaceship

# antigen bundle brew
# antigen bundle command-not-found
# antigen bundle git
# antigen bundle node
# antigen bundle npm
# antigen bundle yarn
# antigen bundle zsh-users/zsh-syntax-highlighting
# antigen bundle lukechilds/zsh-nvm

# antigen apply

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Don't show this weird NPM package info
# SPACESHIP_PACKAGE_SHOW=false

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
