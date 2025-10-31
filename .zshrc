# Add Node and npm to PATH
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Claude Code and other things
export PATH="$HOME/.local/bin:$PATH"

# Homebrew (only if directory exists/on Darwin)
if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  # Make OpenSSL available in PATH on Apple Silicon
  export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
fi

# Config a better version of ls and tree view
alias ls="eza -lhmua --group-directories-first"
alias tree="eza -Ta --git-ignore --ignore-glob=.git --level=3"

# Enable Ctrl + arrow keys to navigate words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
# Enable Ctrl + backspace to delete the previous words
bindkey '^H' backward-kill-word
bindkey '5~' kill-word

# Clean up Docker containers, images, networks, and volumes
function docker-clean {
  docker stop $(docker ps -q) 2>/dev/null || true
  docker system prune -af --volumes
}

# Zi initialization
source "$HOME/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi
zicompinit

# Auto suggestions
zi light zsh-users/zsh-autosuggestions

# Syntax highlighting for commands
zi light zsh-users/zsh-syntax-highlighting

# For `z` to quickly switch between commonly used directories
zi light agkozak/zsh-z

# Load Pure, a clean and simple theme
autoload -U promptinit; promptinit
PURE_PROMPT_SYMBOL="➜"
prompt pure
