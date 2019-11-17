source ~/.zsh/antigen/antigen.zsh

# Due to a permissions issue, pure-prompt didn't automatically
# create some necessary symbolic links :/
fpath+=('/home/kincaid/n/lib/node_modules/pure-prompt/functions')

# Config a better version of ls and tree view
alias ls="exa -lhmua --group-directories-first"
alias tree="exa -Ta --git-ignore --ignore-glob=.git --level=3"

# Load Pure, a clean and simple theme
autoload -U promptinit; promptinit
PURE_PROMPT_SYMBOL="➜"
prompt pure

# Syntax highlighting for commands
antigen bundle zsh-users/zsh-syntax-highlighting

# Auto suggestions
antigen bundle zsh-users/zsh-autosuggestions
