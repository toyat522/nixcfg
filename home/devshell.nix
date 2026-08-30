{ pkgs }:

let
  neovimConfigured = pkgs.neovim.override {
    configure = {
      customRC = ''
        lua vim.opt.runtimepath:prepend("${./nvim}")
        luafile ${./nvim}/init.lua
      '';
      packages.devshell.start = import ./nvim/plugins.nix pkgs;
    };
  };

  # Use C-b prefix for devshell, since it is likely used inside SSH session
  tmuxDevshellConf = pkgs.writeTextFile {
    name = "tmux-devshell.conf";
    text = ''
      source-file ${./tmux/tmux.conf}
      unbind C-a
      set -g prefix C-b
      bind C-b send-prefix
    '';
  };

  tmuxConfigured = pkgs.writeShellScriptBin "tmux" ''
    exec ${pkgs.tmux}/bin/tmux -L nixdevshell -f ${tmuxDevshellConf} "$@"
  '';

  zshRc = import ./zsh.nix { inherit pkgs; };
  zdotdir = pkgs.writeTextDir ".zshrc" ''
    ${zshRc.instantPrompt}
    ${zshRc.body}
  '';
in
pkgs.mkShellNoCC {
  packages = (import ./headless.nix pkgs) ++ (with pkgs; [
    neovimConfigured
    tmuxConfigured
    zsh
  ]);

  shellHook = ''
    export ZDOTDIR=${zdotdir}
    export SHELL=${pkgs.zsh}/bin/zsh
    export EDITOR=nvim
    export VISUAL=nvim
  '';
}
