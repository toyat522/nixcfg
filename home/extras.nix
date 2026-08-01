{ config, pkgs, lib, ... }:

let
  oriedita = pkgs.callPackage ./pkgs/oriedita.nix { };
in

{
  imports = [ ./fcitx.nix ];

  home.packages = with pkgs; [
    claude-code
    imagemagick
    obsidian
    oriedita
    texlive.combined.scheme-medium
    thunderbird
  ];

  # Prevent autostart of fcitx5 by GNOME; only allow systemd service launch
  xdg.configFile."autostart/org.fcitx.Fcitx5.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';

  # Start fcitx5 via systemd with classicui disabled
  systemd.user.services.fcitx5-daemon.Service.ExecStart = lib.mkForce
    "${config.i18n.inputMethod.fcitx5.fcitx5-with-addons.override { addons = config.i18n.inputMethod.fcitx5.addons; }}/bin/fcitx5 --disable classicui";
}
