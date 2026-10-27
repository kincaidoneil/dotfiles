# Add Node and npm to PATH
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Claude Code and other things
export PATH="$HOME/.local/bin:$PATH"

# Homebrew, at its macOS or Linux prefix
if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  # Make OpenSSL available in PATH on Apple Silicon
  export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
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

function kill-port() {
  pids=$(lsof -ti :$1)
  if [ -z "$pids" ]; then
    echo "No process found on port $1"
  else
    echo "$pids" | xargs kill -9
    echo "Killed processes on port $1: $(echo $pids | tr '\n' ' ')"
  fi
}

# Remove the two eMudhra-compromised roots from /etc/ssl/cert.pem, per
# https://support.apple.com/en-us/149555. macOS updates can restore them.
CERT_PEM_ROOTS=(
  '=== /C=IN/OU=emSign PKI/O=eMudhra Technologies Limited/CN=emSign ECC Root CA - G3'
  '=== /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services'
)
function fix-cert-pem {
  [ -e /etc/ssl/cert.pem.orig ] || sudo cp -p /etc/ssl/cert.pem /etc/ssl/cert.pem.orig || return 1
  local root t
  for root in "${CERT_PEM_ROOTS[@]}"; do
    t=$(mktemp) && awk -v s="$root" '/^(===|###) /{skip=0} $0==s{skip=1} !skip' /etc/ssl/cert.pem > "$t" \
      && [ -s "$t" ] && sudo install -m 0644 -o root -g wheel "$t" /etc/ssl/cert.pem
    rm -f "$t"
  done
  check-cert-pem && echo "cert.pem: both roots removed."
}
function check-cert-pem {
  ! /usr/bin/openssl crl2pkcs7 -nocrl -certfile /etc/ssl/cert.pem | /usr/bin/openssl pkcs7 -print_certs -noout \
    | grep -qE 'emSign ECC Root CA - G3|AAA Certificate Services'
}
# Recheck only when the file changes; remember its mtime and size once it passes.
if [[ $OSTYPE == darwin* && -r /etc/ssl/cert.pem ]]; then
  _cert_pem_state="$HOME/.cache/cert-pem-mtime"
  _cert_pem_mtime=$(stat -f '%m %z' /etc/ssl/cert.pem)
  if [[ "$(cat "$_cert_pem_state" 2>/dev/null)" != "$_cert_pem_mtime" ]]; then
    if check-cert-pem; then
      mkdir -p "${_cert_pem_state:h}" && echo "$_cert_pem_mtime" > "$_cert_pem_state"
    else
      print -P "%F{red}WARNING:%f /etc/ssl/cert.pem trusts a compromised eMudhra root again. Run: fix-cert-pem"
    fi
  fi
  unset _cert_pem_state _cert_pem_mtime
fi

# Zi initialization. Its installer moved from ~/.zi to ~/.local/share/zi.
for _zi in "$HOME/.local/share/zi/bin/zi.zsh" "$HOME/.zi/bin/zi.zsh"; do
  [[ -r $_zi ]] && { source "$_zi"; break; }
done
unset _zi
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
# Skip the per-prompt `git fetch` (network round trip on every enter, ~1-2s in a repo)
PURE_GIT_PULL=0
prompt pure

# opencode
export PATH=/Users/kincaid/.opencode/bin:$PATH

# pnpm
export PNPM_HOME="/Users/kincaid/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# mise
command -v mise >/dev/null && eval "$(mise activate zsh)"
