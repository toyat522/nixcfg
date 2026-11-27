#!/usr/bin/env bash
set -euo pipefail

cd -- "$(dirname -- "$0")/.."
source_path="$(nix build .#swaylock-effects-source --no-link --print-out-paths)"
build_dir="$(mktemp -d)"
trap 'rm -rf -- "$build_dir"' EXIT

export PATH=/usr/bin:/bin
unset LD_LIBRARY_PATH

# Install dependencies
sudo apt install -y sway swaybg swaylock swayidle \
  xdg-desktop-portal-wlr xdg-desktop-portal-gtk \
  build-essential meson ninja-build pkg-config libpam0g-dev \
  libwayland-dev wayland-protocols libxkbcommon-dev libcairo2-dev libgdk-pixbuf-2.0-dev

meson setup "$build_dir/build" "$source_path" \
  --sysconfdir=/etc -Dpam=enabled -Dman-pages=disabled -Dsse=false
meson compile -C "$build_dir/build"

# Install only the executable, preserving the distribution's PAM configuration
sudo install -D -m 755 "$build_dir/build/swaylock" /usr/local/bin/swaylock-effects
sudo install -D -m 755 platforms/sway-session.sh \
  /usr/local/bin/nixcfg-sway-session
sudo install -D -m 644 platforms/sway-nvidia.desktop \
  /usr/share/wayland-sessions/sway-nvidia.desktop
