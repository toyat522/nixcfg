{ config, pkgs, lib, ... }:

{
  imports = [
    ../../modules/home/terminal.nix
    ../../modules/home/desktop.nix
    ../../modules/home/sway
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

  xdg.configFile."sway/config".text = lib.mkAfter ''
    output eDP-1 scale 2 position 0 0
    output HDMI-A-1 mode 3440x1440 scale 2 position 0 -720
  '';

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
