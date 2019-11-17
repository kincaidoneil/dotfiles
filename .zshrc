source ~/.zsh/antigen/antigen.zsh

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

# Syntax highlighting for commands
antigen bundle zsh-users/zsh-syntax-highlighting

# Auto suggestions
antigen bundle zsh-users/zsh-autosuggestions
