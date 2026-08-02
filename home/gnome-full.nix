{ config, pkgs, lib, ... }:

{
  imports = [ ./gnome-basic.nix ./extras.nix ];

  # GDM autostarts fcitx5 via the XDG desktop file without --disable classicui, racing the systemd service.
  # Hide it so GNOME ignores it and only the systemd service (below) launches fcitx5.
  xdg.configFile."autostart/org.fcitx.Fcitx5.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';

  # Under GNOME, graphical-session.target activates the fcitx5 service.
  # Disable classicui here since GNOME/Wayland draws its own IM UI.
  systemd.user.services.fcitx5-daemon.Service.ExecStart = lib.mkForce
    "${config.i18n.inputMethod.fcitx5.fcitx5-with-addons.override { addons = config.i18n.inputMethod.fcitx5.addons; }}/bin/fcitx5 --disable classicui";
}
