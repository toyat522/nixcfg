{ pkgs, ... }:

let
  oriedita = pkgs.callPackage ./pkgs/oriedita.nix { };
in

{
  imports = [ ./fcitx.nix ];

  home.packages = with pkgs; [
    bitwarden-cli
    claude-code
    gimp
    imagemagick
    localsend
    obsidian
    oriedita
    texlive.combined.scheme-medium
    thunderbird
  ];
}
