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

  tmuxConfigured = pkgs.writeShellScriptBin "tmux" ''
    exec ${pkgs.tmux}/bin/tmux -f ${./tmux/tmux.conf} "$@"
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
