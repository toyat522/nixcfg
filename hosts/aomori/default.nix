{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix

    ../../modules/nixos/base.nix
    ../../modules/nixos/sway.nix
    ../../modules/nixos/users.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "aomori";

  # NixOS release that is compatible with this configuration
  system.stateVersion = "26.05";
}
