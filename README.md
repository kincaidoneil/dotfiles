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

#### Setup on a fresh Linux box

Before running the install script, run this as root to create a new sudo account:

```bash
curl -s https://raw.githubusercontent.com/kincaidoneil/dotfiles/main/add-user.sh | bash -s
```

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
