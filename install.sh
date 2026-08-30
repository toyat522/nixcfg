#!/usr/bin/env bash
set -e

# Install Nix package manager
if [ ! -d /nix ]; then
  curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon
fi

# Source the daemon profile to use Nix for the rest of this script
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# Enable flakes
mkdir -p ~/.config/nix/
if ! grep -qs 'experimental-features.*flakes' ~/.config/nix/nix.conf; then
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

# Add nixpkgs registry
nix registry add flake:nixpkgs github:NixOS/nixpkgs/nixos-26.05

# Install Home Manager
nix-channel --add https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz home-manager
nix-channel --update
if ! command -v home-manager >/dev/null 2>&1; then
  nix-shell '<home-manager>' -A install
fi
