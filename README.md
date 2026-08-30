# nixcfg

This repository contains my NixOS and Home Manager configurations that build my systems.

## Screenshots

### Sway

![sway](./img/sway.png)

![sway_nvim](./img/sway_nvim.png)

## Setup

### NixOS

1. Install [Home Manager](https://nix-community.github.io/home-manager/installation/standalone.html).

```
nix-channel --add https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

2. Create a new directory in `hosts/` with the hostname as the directory name.

3. Copy `hardware-configuration.nix` from `/etc/nixos/hardware-configuration.nix`:

```
cp /etc/nixos/hardware-configuration.nix ./hosts/<hostname>/hardware-configuration.nix
```

4. Populate `./hosts/<hostname>/default.nix`.

5. Populate `flake.nix` with a new NixOS configuration.

### Non-NixOS Systems

1. Run the installation script:

```
./install.sh
```

2. Install the packages via Nix and Home Manager:

```
home-manager switch --flake .#<config> --impure
```

> See the "Usage" section for available configurations

3. Add path to Nix's zsh to `/etc/shells`, which lists valid login shells:

```
echo /home/<username>/.nix-profile/bin/zsh | sudo tee -a /etc/shells
```

4. Change default login shell to Nix's zsh:

```
chsh -s /home/<username>/.nix-profile/bin/zsh
```

### Secrets

Secret environment variables (API keys, tokens) are kept out of the this repo. On login,
zsh sources `~/.config/secrets.env` if it exists.

Example:

```
export ANTHROPIC_API_KEY=...
export GITHUB_TOKEN=...
```

The file is optional per host. If it is absent, login proceeds normally.

## Usage

### NixOS

```
sudo nixos-rebuild switch --flake .#<hostname>
```

### Non-NixOS

```
home-manager switch --flake .#<config> --impure
```

> Configuration options are `intel`, `nvidia`, or `jetson` depending on the GPU type.

### Creating a Devshell

To create devshell, run the following command:

```
nix develop -c zsh
```

This will start an isolated zsh development shell which includes the custom shell configurations
(including neovim, tmux, etc).

## Troubleshooting

### Enter tty from greeter

Press Ctrl+Alt+F3.
