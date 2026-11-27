{ pkgs }:

let
  zshRc = import ./zsh.nix { inherit pkgs; };
  zdotdir = pkgs.writeTextDir ".zshrc" ''
    ${zshRc.instantPrompt}
    ${zshRc.body}
  '';
  tools = (import ../cli-tools.nix pkgs) ++ [
    (import ../neovim { inherit pkgs; })
    (import ../tmux { inherit pkgs; portable = true; })
    pkgs.zsh
  ];
in
pkgs.writeShellScriptBin "nixcfg-zsh" ''
  export PATH=${pkgs.lib.makeBinPath tools}:$PATH
  export ZDOTDIR=${zdotdir}
  export SHELL=${pkgs.zsh}/bin/zsh
  export EDITOR=nvim
  export VISUAL=nvim
  exec ${pkgs.zsh}/bin/zsh "$@"
''
