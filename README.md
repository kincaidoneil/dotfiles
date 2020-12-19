# Kincaid's Config

## Install on Linux

#### Create new user account as `root`

```bash
source <(curl -s https://raw.githubusercontent.com/kincaidoneil/dotfiles/master/add-user.sh)
```

#### Install packages and settings as `kincaid`

```bash
curl -s https://raw.githubusercontent.com/kincaidoneil/dotfiles/master/install.sh | bash -s
```

**Note**: if running on a DigitalOcean droplet, run with the environment variable `DIGITAL_OCEAN=1` to also install metrics.

#### Import PGP key to configure Git commit signing

```bash
gpg --import <path>
```

## Set up new clients

#### Generate SSH key

```bash
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

Then, add `~/.ssh/id_ed25519.pub` on client on a newline in the `~/.ssh/authorized_keys` file on the server. Refer to [this article](https://cryptsus.com/blog/how-to-secure-your-ssh-server-with-public-key-elliptic-curve-ed25519-crypto.html) for more background.

#### Add SSH config

To simplify connecting, add the server as an entry in the `~/.ssh/config` file on the client:

```
Host <NAME>
  HostName <IP_ADDRESS>
  ForwardAgent yes
  UseKeychain yes
```

## Install on Mac

#### Install Homebrew

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

#### Install Homebrew packages

- _coreutils_: update old versions of Bash things
- _trash_: doesn't permanently delete files
- _exa_: better ls
- _zsh_: awesome shell
- _z_: quickly navigate to oft-visited directories

```bash
brew install trash z git make coreutils exa zsh zsh-autosuggestions zsh-syntax-highlighting gnupg pinentry-mac
```

#### Install Node.js, NPM and n (Node version manager)

```bash
# Install LTS and latest versions of Node
curl -L https://git.io/n-install | bash -s -- -y lts latest
```

Remember to reinitialize shell so it's in the PATH!

#### Install ZSH prompt

```bash
npm i -g pure-prompt
```

#### Copy other configs

```bash
cp .hyper.js ~
cp .zshrc ~
```

#### Set ZSH as default shell

```bash
echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/zsh
```

#### [Setup Git and commit signing](https://nathanhoad.net/how-to-git-signing-commits/)
