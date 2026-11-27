#!/bin/sh
set -e

if [ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
elif [ -r "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

export XDG_CURRENT_DESKTOP=sway
exec /usr/bin/sway "$@"
