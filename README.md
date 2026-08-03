# nixcfg

# Adding a New Host

1. Create a new directory in `hosts/` with the hostname as the directory name.

2. Copy `hardware-configuration.nix` from `/etc/nixos/hardware-configuration.nix`:

```
sudo cp /etc/nixos/hardware-configuration.nix ./hosts/<hostname>/hardware-configuration.nix
```

3. Change the file ownership from root to user:

```
sudo chown <username>:users ./hosts/<hostname>/hardware-configuration.nix
```

4. Populate `./hosts/<hostname>/default.nix`.

5. Populate `flake.nix` with a new NixOS configuration.

# Switching Configuration

```
sudo nixos-rebuild switch --flake .#<hostname>
```
