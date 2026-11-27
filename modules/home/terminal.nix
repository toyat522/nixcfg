{ pkgs, lib, ... }:

{
  home.packages = (import ../../packages/cli-tools.nix pkgs) ++ [
    (import ../../packages/neovim { inherit pkgs; })
    (import ../../packages/tmux { inherit pkgs; })
  ];

  home.sessionPath = [ "$HOME/.local/bin" ];
  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    settings.init.defaultBranch = "main";
  };
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  programs.zsh =
    let zshRc = import ../../packages/shell/zsh.nix { inherit pkgs; };
    in {
      enable = true;
      enableCompletion = false;
      initContent = lib.mkMerge [
        (lib.mkOrder 500 zshRc.instantPrompt)
        zshRc.body
      ];
    };
}
