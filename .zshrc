source <(antibody init)

# Due to a permissions issue with /usr/local/shared/zsh (?), pure isn't automatically
# setting up some necessary symbolic links :/
# https://github.com/sindresorhus/pure/issues/282#issuecomment-276931410
fpath+=('/home/kincaid/n/lib/node_modules/pure-prompt/functions')

# Config a better version of ls and tree view
alias ls="exa -lhmua --group-directories-first"
alias tree="exa -Ta --git-ignore --ignore-glob=.git --level=3"

# Load Pure, a clean and simple theme
autoload -U promptinit; promptinit
PURE_PROMPT_SYMBOL="➜"
prompt pure

# Auto suggestions
antibody bundle zsh-users/zsh-autosuggestions

# Syntax highlighting for commands
antibody bundle zsh-users/zsh-syntax-highlighting

# Node, NPM
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

# Rust, Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# Fix issues with GPG signing:
# https://github.com/keybase/keybase-issues/issues/2798
export GPG_TTY=$(tty)
