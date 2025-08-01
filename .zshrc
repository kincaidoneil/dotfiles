# Add Node and npm to PATH
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

# Bun completions
[ -s "/Users/kincaid/.bun/_bun" ] && source "/Users/kincaid/.bun/_bun"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/kincaid/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Claude Code and other things
export PATH="$HOME/.local/bin:$PATH"

# Homebrew (only if directory exists/on Darwin)
[ -d "/opt/homebrew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Make OpenSSL available in PATH on Apple Silicon
[ -d "/opt/homebrew" ] && export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"

# Config a better version of ls and tree view
alias ls="eza -lhmua --group-directories-first"
alias tree="eza -Ta --git-ignore --ignore-glob=.git --level=3"

# Enable Ctrl + arrow keys to navigate words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
# Enable Ctrl + backspace to delete the previous words
bindkey '^H' backward-kill-word
bindkey '5~' kill-word

# Export helper to stop and remove all running Docker containers
function docker-clean {
  running_containers=$(docker ps -q)
  if [[ -z "$running_containers" ]]
  then
    echo "No Docker containers running."
  else
    docker stop $(docker ps -q)
    docker rm $(docker ps -a -q)
  fi
}

# Zi initializaiton
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
