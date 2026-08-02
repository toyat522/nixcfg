{ pkgs, ... }:

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
}
