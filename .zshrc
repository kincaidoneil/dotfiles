# Add Node and npm to PATH
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

# Setup Flutter and JDK (intended only for Mac, install script didn't install Java on linux)
export PATH="$PATH:$HOME/flutter/bin"
[ -f /usr/libexec/java_home ] && export JAVA_HOME=$(/usr/libexec/java_home)

# Homebrew (only if directory exists/on Darwin)
[ -d "/opt/homebrew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Make OpenSSL available in PATH on Apple Silicon
[ -d "/opt/homebrew" ] && export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"

# Config a better version of ls and tree view
alias ls="exa -lhmua --group-directories-first"
alias tree="exa -Ta --git-ignore --ignore-glob=.git --level=3"

# Fix issues with GPG signing: https://github.com/keybase/keybase-issues/issues/2798
export GPG_TTY=$(tty)

# Enable Ctrl + arrow keys to navigate words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
# Enable Ctrl + backspace to delete the previous words
bindkey '^H' backward-kill-word
bindkey '5~' kill-word

# Export helper to stop and remove all running Docker containers
function docker-clean {
  running_containers=`docker ps -q`
  if [[ -z "$running_containers" ]]
  then
    echo "No Docker containers running."
  else
    docker stop `docker ps -q`
    docker rm `docker ps -a -q`
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

# Due to a permissions issue with /usr/local/shared/zsh (?), Pure didn't automatically
# set up some necessary symbolic links: https://github.com/sindresorhus/pure/issues/282#issuecomment-276931410
fpath+=('/home/kincaid/n/lib/node_modules/pure-prompt/functions')

# Homebrew changed locations on M1, fix Pure so it can reference Zsh: https://github.com/sindresorhus/pure/issues/584#issuecomment-989054653
fpath+=('/opt/homebrew/share/zsh/site-functions')

# Load Pure, a clean and simple theme
autoload -U promptinit; promptinit
PURE_PROMPT_SYMBOL="➜"
prompt pure
