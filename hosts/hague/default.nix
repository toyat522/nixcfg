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

  services.tailscale.enable = true;

  networking = {
    hostName = "hague";
    networkmanager.enable = true;

    firewall = {
      trustedInterfaces = [ "tailscale0" ];

      allowedTCPPorts = [
        22000  # Syncthing file transfer
      ];

      allowedUDPPorts = [
        21027  # Syncthing discovery
        22000  # Syncthing file transfer
        config.services.tailscale.port
      ];
    };
  };

  time.timeZone = "America/Los_Angeles";

  # NixOS release that is compatible with this configuration
  system.stateVersion = "26.05";
}
