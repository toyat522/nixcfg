{ pkgs, ... }:

{
  imports = [ ./common.nix ];

  home.packages = with pkgs; [
    (catppuccin-gtk.override { accents = [ "mauve" ]; variant = "mocha"; size = "standard"; })
    (catppuccin-papirus-folders.override { flavor = "mocha"; accent = "mauve"; })
    wl-clipboard
    xclip
  ];

  home.pointerCursor = {
    name = "catppuccin-mocha-dark-cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
    gtk.enable = true;
  };

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:swapescape" ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "catppuccin-mocha-mauve-standard";
      icon-theme = "Papirus-Dark";
      cursor-theme = "catppuccin-mocha-dark-cursors";
      cursor-size = 24;
    };

    # Ctrl+Alt+t to open kitty on GNOME
    "org/gnome/settings-daemon/plugins/media-keys" = {
      terminal = [];
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control><Alt>t";
      command = "kitty";
      name = "terminal";
    };
  };
}
