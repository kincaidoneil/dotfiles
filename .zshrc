# Added by n-install (see http://git.io/n-install-repo).
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

# Config a better version of ls and tree view
alias ls="exa -lhmua --group-directories-first"
alias tree="exa -Ta --git-ignore --ignore-glob=.git --level=3"

# Load Pure, a clean and simple theme
autoload -U promptinit; promptinit
PURE_PROMPT_SYMBOL="➜"
prompt pure

# Syntax highlighting as I'm typing commands -- really nice
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh