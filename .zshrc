# Config a better version of ls and tree view
alias ls="exa -lhmua --group-directories-first"
alias tree="exa -Ta --git-ignore --ignore-glob=.git --level=3"

# Load Pure, a clean and simple theme
autoload -U promptinit; promptinit
PURE_PROMPT_SYMBOL="➜"
prompt pure

# Syntax highlighting for commands
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Auto suggestions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Use Z to quickly navigate between directories
. `brew --prefix`/etc/profile.d/z.sh

# Used by n, my Node.js version manager
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
