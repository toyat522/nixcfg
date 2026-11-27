{ pkgs, portable ? false }:

let
  config = pkgs.writeText "tmux.conf" (''
    set -g default-shell ${pkgs.zsh}/bin/zsh
    source-file ${./tmux.conf}
  '' + pkgs.lib.optionalString portable ''
    unbind C-a
    set -g prefix C-b
    bind C-b send-prefix
  '');
in
pkgs.writeShellScriptBin "tmux" ''
  exec ${pkgs.tmux}/bin/tmux ${pkgs.lib.optionalString portable "-L nixdevshell"} -f ${config} "$@"
''
