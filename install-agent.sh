#!/bin/bash
# Sets up a remote agent machine, such as a Claude Code cloud environment, with the parts of
# these dotfiles agents need: the agent gh wrapper and the global agent instructions. It is
# not the full install.sh. See README.md, "Remote agents".
#
#   curl -fsSL https://raw.githubusercontent.com/kincaidoneil/dotfiles/main/install-agent.sh | bash
#
# The App credentials are not set here. Set AGENT_GITHUB_APP_ID and AGENT_GITHUB_APP_KEY in
# the environment's variables, which agents see when their sessions run.

set -euo pipefail

src=${DOTFILES_URL:-https://raw.githubusercontent.com/kincaidoneil/dotfiles/main}

# The wrapper has to come before the real gh on PATH. /usr/local/bin does on stock Linux and
# macOS, and cloud setup scripts run as root, so they can write it.
if [[ -n "${AGENT_BIN_DIR:-}" ]]; then
  bin=$AGENT_BIN_DIR
elif [[ -w /usr/local/bin ]]; then
  bin=/usr/local/bin
else
  bin="$HOME/.local/bin"
fi

for tool in curl openssl gh; do
  command -v "$tool" > /dev/null || { echo "install-agent: $tool is required" >&2; exit 1; }
done

fetch() {
  curl -fsSL "$src/$1" -o "$2"
}

mkdir -p "$bin" "$HOME/.claude" "$HOME/.codex"
fetch agent-bin/gh "$bin/gh"
fetch agent-bin/agent-github-token "$bin/agent-github-token"
chmod +x "$bin/gh" "$bin/agent-github-token"

# Claude Code reads ~/.claude/CLAUDE.md and Codex reads ~/.codex/AGENTS.md as user instructions.
fetch AGENTS.md "$HOME/.claude/CLAUDE.md"
cp "$HOME/.claude/CLAUDE.md" "$HOME/.codex/AGENTS.md"

if [[ "$(command -v gh)" != "$bin/gh" ]]; then
  echo "install-agent: $bin is not ahead of the real gh on PATH. Add: export PATH=\"$bin:\$PATH\"" >&2
fi
echo "install-agent: installed the gh wrapper in $bin and agent instructions in ~/.claude and ~/.codex"
