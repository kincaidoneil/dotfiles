# Kincaid's Config

#### Install

For installation on a fresh Linux box, create new user account as `root`:

```bash
source <(curl -s https://raw.githubusercontent.com/kincaidoneil/dotfiles/main/add-user.sh)
```

On Linux or macOS, run install script for packages and settings:

```bash
curl -s https://raw.githubusercontent.com/kincaidoneil/dotfiles/main/install.sh | bash -s
```

Installs packages with `apt` on Debian, or `brew` on macOS (\*only supports Apple Silicon as some Homebrew paths changed).

If running on a DigitalOcean droplet, run with the environment variable `DIGITAL_OCEAN=1` to also install metrics.

#### Setup SSH and commit signing

Use 1Password to [manage SSH keys](https://developer.1password.com/docs/ssh/) and configure [SSH commit signing](https://developer.1password.com/docs/ssh/git-commit-signing).

#### Configure GPG commit signing

_(Skip if using 1Password and/or SSH commit signing.)_

Import GPG secret key:

```bash
gpg --import [PATH]
```

If the key is expired, GPG may cryptically fail to sign with a `No secret key` error. To extend it:

```bash
gpg --edit-key [KEY_ID]
> key 1 # Select subkey, too!
> expire # Follow prompts to extend expiration
> save
```

#### Generate new SSH key

_(Prefer using 1Password to generate new keys.)_

```bash
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

#### Add SSH pubkey to remote

Add `~/.ssh/id_ed25519.pub` on client on a newline in the `~/.ssh/authorized_keys` file on the server. Refer [here](https://cryptsus.com/blog/how-to-secure-your-ssh-server-with-public-key-elliptic-curve-ed25519-crypto.html) for more background.

#### Add SSH config

To simplify connecting, add the server as an entry in the `~/.ssh/config` file on the client:

```
Host <NAME>
  HostName <IP_ADDRESS>
  ForwardAgent yes
  UseKeychain yes
```

#### Cleanup

```bash
cd ~
rm -rf \
 n \
 .cargo \
 .rustup \
 .npm \
 .zi \
 .zshrc \
 .gitconfig
```
