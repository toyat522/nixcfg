# The interactive zsh config, in ONE place. Consumed by:
#   - home/common.nix    (via programs.zsh.initContent) for the full Home Manager setup
#   - home/devshell.nix  (baked into an isolated ZDOTDIR) for `nix develop`
#
# Everything here uses shell-level expansion ($HOME, $XDG_*, env seams) rather than
# Home Manager's `config.home.homeDirectory`, so the exact same text is correct both
# in your real home and inside the throwaway devshell.
{ pkgs }:

{
  # powerlevel10k instant prompt — must run before anything prints. Kept separate so
  # each consumer can place it at the very top of its rc.
  instantPrompt = ''
    if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
      source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
    fi
  '';

  body = ''
    # vi insert-mode keymap (was programs.zsh.defaultKeymap = "viins")
    bindkey -v

    # prompt
    source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    source ${./p10k-config}/p10k.zsh

    # completion (was programs.zsh.enableCompletion + zsh-completions plugin)
    fpath+=(${pkgs.zsh-completions}/share/zsh/site-functions)
    autoload -U compinit && compinit -C

    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
    zstyle ':completion:*' menu no
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
    zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
    source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.zsh

    # suggestions + highlighting (was programs.zsh.plugins)
    source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    # history (was programs.zsh.history)
    export HISTFILE="$HOME/.zsh_history"
    HISTSIZE=5000
    SAVEHIST=5000
    setopt hist_ignore_dups hist_ignore_all_dups hist_ignore_space hist_expire_dups_first

    # aliases (was programs.zsh.shellAliases)
    alias bat='bat -p'
    alias cat='bat -p'
    alias ls='eza -g --color=always'
    alias ssh='TERM=xterm-256color ssh'
    alias tks='tmux kill-session'
    alias vi='nvim'
    alias vim='nvim'

    # fzf + zoxide integration (was programs.fzf/zoxide.enableZshIntegration)
    source <(${pkgs.fzf}/bin/fzf --zsh)
    eval "$(${pkgs.zoxide}/bin/zoxide init zsh --cmd cd)"

    [[ -r "''${XDG_CONFIG_HOME:-$HOME/.config}/secrets.env" ]] && source "''${XDG_CONFIG_HOME:-$HOME/.config}/secrets.env"
  '';
}
