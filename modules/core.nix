{ config, lib, pkgs, ... }:

{
  # Enable Flakes and the new nix CLI
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable the OpenSSH daemon
  services.openssh.enable = true;

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
}
