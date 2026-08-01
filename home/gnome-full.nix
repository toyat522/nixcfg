{ config, pkgs, lib, ... }:

let
  oriedita = pkgs.callPackage ./pkgs/oriedita.nix { };
in

{
  imports = [ ./gnome-basic.nix ];

  home.packages = with pkgs; [
    claude-code
    imagemagick
    obsidian
    oriedita
    texlive.combined.scheme-medium
    thunderbird
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
      settings = {
        globalOptions = {
          "Hotkey/TriggerKeys" = {
            "0" = "Control+space";
            "1" = "Zenkaku_Hankaku";
          };
        };
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "mozc";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "mozc";
        };
      };
    };
  };

  # Remove the fcitx UI
  systemd.user.services.fcitx5-daemon.Service.ExecStart = lib.mkForce
    "${config.i18n.inputMethod.fcitx5.fcitx5-with-addons.override { addons = config.i18n.inputMethod.fcitx5.addons; }}/bin/fcitx5 --disable classicui";
}
