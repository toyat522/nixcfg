{ pkgs, ... }:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = [ pkgs.swaylock-effects ];
  };

  # File picker, screen sharing, etc. for Wayland apps
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security.polkit.enable = true;

  security.pam.services.swaylock = {};

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  programs.xfconf.enable = true;   # Thunar preferences service
  services.gvfs.enable = true;     # trash, remote/network mounts
  services.tumbler.enable = true;  # thumbnail generation

  # Enable catppuccin theme SDDM greeter
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha-mauve";
    extraPackages = with pkgs.kdePackages; [ qtsvg qt5compat ];
  };
  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override { disableBackground = true; })
  ];
}
