## Kincaid's Dotfiles

#### Install (macOS, Linux)

```bash
curl -s https://raw.githubusercontent.com/kincaidoneil/dotfiles/main/install.sh | bash -s
```

- Installs Homebrew (if not present)
- Installs development tools and runtimes
- Symlinks dotfiles (`.zshrc`, `.gitconfig`)
- Configures Zsh with plugins
- Sets up Claude Code and agent skills

Skills come from two places. `skills-lock.json` pins the ones the [skills CLI](https://skills.sh) installs, and `skills/` holds the ones we maintain by hand. The install script links both into `~/.claude/skills` and `~/.agents/skills`, so Claude Code and Codex see the same set.

#### Setup on a fresh Linux box

Before running the install script, run this as root to create a new sudo account:

```bash
curl -s https://raw.githubusercontent.com/kincaidoneil/dotfiles/main/add-user.sh | bash -s
```

#### Agent GitHub identity

Agents comment, review, and open PRs as the `kincaidoneil-agent` GitHub App (App ID `5911907`), not as me. `agent-bin/gh` wraps `gh`: when `AGENT_GITHUB_APP_ID` and `AGENT_GITHUB_APP_KEY` are set, it runs `gh` with a 1-hour token from `agent-bin/agent-github-token`; otherwise it runs `gh` as me. `.zshrc` puts it first on `PATH`.

- **Locally**, `claude-settings.json` sets both variables for Claude Code only, so my own terminal is unaffected. The key is a 1Password reference (`op://…`), read with Touch ID at most about once an hour.
- **Repos:** a token covers every repo the App is installed on. Add repos under the App's settings, Install App → Configure.
- **Remote agents** need their own setup; see below.
- **Auth uses the App's private key** (Key pairs), not client secrets, which are only for acting as a signed-in user.

#### Remote agents

Remote agent machines, such as Claude Code cloud environments, don't get the full install. `install-agent.sh` installs only what agents need there: the `gh` wrapper (in `/usr/local/bin` when it's writable, otherwise `~/.local/bin`) and `AGENTS.md` as `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`. It reads from `main` on GitHub, so push changes before they reach remote agents.

To set up a **Claude Code cloud environment** (at claude.ai/code, under the environment's settings):

1. **Setup script:**

   ```bash
   curl -fsSL https://raw.githubusercontent.com/kincaidoneil/dotfiles/main/install-agent.sh | bash
   ```

   It runs as root before the first session, and later sessions reuse a snapshot of the result. The snapshot is rebuilt when the script changes or after about seven days, so new dotfiles commits arrive within a week, or sooner if you edit the script.

2. **Environment variables:** `AGENT_GITHUB_APP_ID=5911907`, and `AGENT_GITHUB_APP_KEY` set to the output of `op read '<cloud key op:// reference>' | base64`. Use the cloud key, not the local one, so a leaked cloud key can be revoked alone. Anyone who can use the environment can read these values.
3. **Network access:** the default allowlist (Limited, with package managers) includes `raw.githubusercontent.com`, which the setup script needs.

Two limits of the GitHub proxy that cloud sessions go through:

- **GraphQL is blocked whatever the token,** so `gh pr` and `gh issue` fail. Agents use `gh api repos/{owner}/{repo}/...` (REST) instead.
- **API calls are limited to the repositories attached to the session.** Minting a token calls `/users/kincaidoneil/installation` and `/app/installations/…`, which aren't repository paths. Whether the proxy allows them hasn't been tested yet.

Codex cloud has setup scripts and environment variables too, but its "secrets" are removed before the agent runs, so the App key has to be a plain environment variable there as well.

#### Keys and signing

Use 1Password to [manage SSH keys](https://developer.1password.com/docs/ssh/) and configure [SSH commit signing](https://developer.1password.com/docs/ssh/git-commit-signing).

<details>
<summary>Legacy GPG/SSH setup</summary>

#### Configure GPG Commit Signing

Import GPG secret key:

```bash
gpg --import [PATH]
```

If the key is expired, extend it:

```bash
gpg --edit-key [KEY_ID]
> key 1 # Select subkey, too!
> expire # Follow prompts to extend expiration
> save
```

You'll need to use an [older revision](https://github.com/kincaidoneil/dotfiles/blob/315dbe3b078480ced80b398e016c152980369c18/.gitconfig-darwin) of `.gitconfig-[PLATFORM]` and manually install GPG tools (`brew install gpg2 pinentry-mac`).

#### Generate New SSH Key

```bash
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

#### Add SSH Pubkey to Remote Server

Add `~/.ssh/id_ed25519.pub` contents to `~/.ssh/authorized_keys` on the remote server. See [this guide](https://cryptsus.com/blog/how-to-secure-your-ssh-server-with-public-key-elliptic-curve-ed25519-crypto.html) for more details.

#### Add SSH Config

Simplify SSH connections by adding entries to `~/.ssh/config`:

```
Host <NAME>
  HostName <IP_ADDRESS>
  ForwardAgent yes
  UseKeychain yes
```

</details>
