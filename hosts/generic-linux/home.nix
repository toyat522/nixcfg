{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/terminal.nix
    ../../modules/home/desktop.nix
    ../../modules/home/gnome.nix
    ../../modules/home/japanese-input.nix
  ];

  home.stateVersion = "26.05";

  programs.git.settings.user = {
    name = "Toya Takahashi";
    email = "toyatakahashi522@gmail.com";
  };

  home.packages = with pkgs; [
    bitwarden-cli
    ffmpeg
    gimp
    imagemagick
    libreoffice
    obsidian
    (callPackage ../../packages/oriedita.nix { })
    remmina
    texlive.combined.scheme-medium
    thunderbird
    vlc
  ];
}
