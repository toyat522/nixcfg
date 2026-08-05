{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix

    ../../modules/core.nix
    ../../modules/sway.nix
    ../../modules/users.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "aomori";
    networkmanager.enable = true;

    # Open port 53317 for LocalSend
    firewall.allowedTCPPorts = [ 22000 53317 ];
    firewall.allowedUDPPorts = [ 21027 22000 53317 ];
  };

  time.timeZone = "America/Los_Angeles";

  # NixOS release that is compatible with this configuration
  system.stateVersion = "26.05";
}
