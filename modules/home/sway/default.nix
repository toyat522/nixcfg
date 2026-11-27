{ config, pkgs, ... }:

let
  swaylock = if config.targets.genericLinux.enable
    then "/usr/local/bin/swaylock-effects"
    else "swaylock";
in
{
  home.packages = with pkgs; [
    autotiling
    bluetui
    brightnessctl
    dex
    dunst
    grim
    rofi
    slurp
    swayidle
    (thunar.override {
      thunarPlugins = [ thunar-archive-plugin thunar-volman ];
    })
    waybar
    wireplumber
    wl-clipboard
    xdg-user-dirs
  ];

  home.sessionVariables._JAVA_AWT_WM_NONREPARENTING = "1";

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
  };

  home.pointerCursor = {
    name = "catppuccin-mocha-dark-cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
    gtk.enable = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  xdg.configFile = {
    "sway/config".text = builtins.replaceStrings
      [ "@swaylock@" "@polkit@" ]
      [ swaylock "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1" ]
      (builtins.readFile ./config);

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
  };
}
