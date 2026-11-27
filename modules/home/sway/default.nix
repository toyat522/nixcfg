{ config, pkgs, ... }:

{
  # GTK theme for GTK apps under sway
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-mauve-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        variant = "mocha";
        size = "standard";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "mauve";
      };
    };
    cursorTheme = {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  xdg.configFile = {
    "sway/config".source = ./config;

    # polkit agent path is nix-store-specific, so we generate a small launcher
    "sway/polkit.sh" = {
      text = ''
        #!/bin/sh
        exec ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      '';
      executable = true;
    };

    # Thunar sidebar directories
    "gtk-3.0/bookmarks".text = ''
      file://${config.home.homeDirectory}/docs
      file://${config.home.homeDirectory}/img
      file://${config.home.homeDirectory}/dls
      file://${config.home.homeDirectory}/dev
    '';

    "bg".source = ../../../assets/wallpapers;
    "dunst/dunstrc".source = ./dunst/dunstrc;

    "rofi/config.rasi".source = ./rofi/config.rasi;
    "rofi/rounded-common.rasi".source = ./rofi/rounded-common.rasi;

    "swaylock/config".source = ./swaylock.conf;

    "waybar/config".source = ./waybar/config;
    "waybar/style.css".source = ./waybar/style.css;
    "waybar/launch.sh" = {
      source = ./waybar/launch.sh;
      executable = true;
    };
  };
}
