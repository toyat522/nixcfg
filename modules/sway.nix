{ pkgs, ... }:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      autotiling
      bluetui
      dex
      dunst
      grim
      brightnessctl
      polkit_gnome
      rofi
      slurp
      swayidle
      swaylock-effects
      waybar
      wl-clipboard
    ];
  };

  # File picker, screen sharing, etc. for Wayland apps
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security.polkit.enable = true;

  security.pam.services.swaylock = {};

  # Enable SDDM greeter on Wayland
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
}
