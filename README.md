# Kincaid's Config

## Install on Linux

TODO Change these to master branch

As `root` user, run:

```bash
source <(curl -s https://raw.githubusercontent.com/kincaidoneil/dotfiles/ko-linux-refresh/add-user.sh)
```

Then, as `kincaid`, run:

```bash
curl -s https://raw.githubusercontent.com/kincaidoneil/dotfiles/ko-linux-refresh/install.sh | bash -s
```

## Install on Mac

### Install Homebrew

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Install Homebrew packages

- _coreutils_: update old versions of Bash things
- _trash_: doesn't permanently delete files
- _exa_: better ls
- _zsh_: awesome shell
- _z_: quickly navigate to oft-visited directories

```bash
brew install trash z git make coreutils exa zsh zsh-autosuggestions zsh-syntax-highlighting gnupg pinentry-mac
```

### Install Node.js, NPM and n (Node version manager)

```bash
# Install LTS and latest versions of Node
curl -L https://git.io/n-install | bash -s -- -y lts latest
```

Remember to reinitialize shell so it's in the PATH!

### Install ZSH prompt

```bash
npm i -g pure-prompt
```

### Copy other configs

```bash
cp .hyper.js ~
cp .zshrc ~
```

### Set ZSH as default shell

```bash
echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/zsh
```

### [Setup Git and commit signing](https://nathanhoad.net/how-to-git-signing-commits/)
