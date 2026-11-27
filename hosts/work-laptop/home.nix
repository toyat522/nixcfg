{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/terminal.nix
    ../../modules/home/desktop.nix
    ../../modules/home/gnome.nix
    ../../modules/home/japanese-input.nix
  ];

  home.username = "ttakahashi";
  home.homeDirectory = "/home/ttakahashi";
  home.stateVersion = "26.05";

  programs.git.settings.user = {
    name = "Toya Takahashi";
    email = "ttakahashi@nvidia.com";
  };

  home.sessionPath = [ "$HOME/dev/ngc-cli" ];
  home.sessionVariables.ISAAC_ROS_WS = "${config.home.homeDirectory}/dev/workspaces/isaac/";

  home.packages = with pkgs; [
    bitwarden-cli
    ffmpeg
    imagemagick
    obsidian
    remmina
    texlive.combined.scheme-medium
    vlc
  ];
}
