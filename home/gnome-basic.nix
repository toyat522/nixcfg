{ ... }:

{
  imports = [ ./common.nix ];

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:swapescape" ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    # Ctrl+Alt+t to open Alacritty on GNOME
    "org/gnome/settings-daemon/plugins/media-keys" = {
      terminal = [];
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control><Alt>t";
      command = "alacritty";
      name = "terminal";
    };
  };
}
