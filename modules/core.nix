{ config, lib, pkgs, ... }:

{
  nix.settings = {
    # Enable Flakes and the new nix CLI
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://ros.cachix.org"  # nix-ros-overlay cachix
    ];
    trusted-public-keys = [
      "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="  # nix-ros-overlay cachix
    ];
  };

  # Enable mDNS for .local hostname resolution
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # Enable the OpenSSH daemon
  services.openssh.enable = true;

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable sound with pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Install zsh
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = lib.mkDefault true;

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim
  ];

  # Set the default system editor to vim
  environment.variables.EDITOR = "vim";

  # Enable Docker
  virtualisation.docker.enable = true;

  # Allow running ARM64 binaries through QEMU software emulation
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.binfmt.preferStaticEmulators = true;
}
