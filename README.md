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
