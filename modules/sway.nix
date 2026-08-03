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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Thunar file manager
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services.gvfs.enable = true;     # trash, remote/network mounts
  services.tumbler.enable = true;  # thumbnail generation

  # Tell JRE to manage resizing itself
  environment.sessionVariables._JAVA_AWT_WM_NONREPARENTING = "1";

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
