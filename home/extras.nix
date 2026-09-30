{ pkgs, ... }:

let
  oriedita = pkgs.callPackage ./pkgs/oriedita.nix { };
  claude-code-latest = pkgs.callPackage ./pkgs/claude-code-latest.nix { };
  codex-latest = pkgs.callPackage ./pkgs/codex-latest.nix { };
in

{
  imports = [ ./fcitx.nix ];

  home.packages = with pkgs; [
    bitwarden-cli
    claude-code-latest
    codex-latest
    ffmpeg
    imagemagick
    obsidian
    remmina
    texlive.combined.scheme-medium
    vlc
  ];
}
