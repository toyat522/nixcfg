{ pkgs, ... }:

{
  imports = [ ./common.nix ];

  xdg.configFile = {
    "sway/config".source = ./sway/config;

    # polkit agent path is nix-store-specific, so we generate a small launcher
    "sway/polkit.sh" = {
      text = ''
        #!/bin/sh
        exec ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      '';
      executable = true;
    };

    "bg".source = ./bg;
    "dunst/dunstrc".source = ./sway/dunst/dunstrc;

    "rofi/config.rasi".source = ./sway/rofi/config.rasi;
    "rofi/rounded-common.rasi".source = ./sway/rofi/rounded-common.rasi;

    "swaylock/config".source = ./sway/swaylock.conf;

    "waybar/config".source = ./sway/waybar/config;
    "waybar/style.css".source = ./sway/waybar/style.css;
    "waybar/launch.sh" = {
      source = ./sway/waybar/launch.sh;
      executable = true;
    };
  };
}
