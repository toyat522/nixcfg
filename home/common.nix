{ config, pkgs, lib, ... }:

{
  home.username = "toyat";
  home.homeDirectory = "/home/toyat";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    bat
    cmake
    eza
    fastfetch
    fd
    file
    firefox
    gcc
    gnumake
    htop
    nerd-fonts.fira-mono
    python3
    ripgrep
    sxiv
    tcpdump
    unzip
    yazi
    zip
  ];

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables = { };

  home.file = { };

  xdg.configFile = {
    "nvim/init.lua".source = ./nvim/init.lua;
    "nvim/lua".source = ./nvim/lua;
    "nvim/ftplugin".source = ./nvim/ftplugin;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf"        = "org.pwmt.zathura-pdf-mupdf.desktop";
      "image/jpeg"             = "sxiv.desktop";
      "image/png"              = "sxiv.desktop";
      "image/gif"              = "sxiv.desktop";
      "image/webp"             = "sxiv.desktop";
      "image/bmp"              = "sxiv.desktop";
      "image/tiff"             = "sxiv.desktop";
      "text/html"              = "firefox.desktop";
      "x-scheme-handler/http"  = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };

  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "kitty.desktop" ];
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop = "${config.home.homeDirectory}";
    documents = "${config.home.homeDirectory}/docs";
    download = "${config.home.homeDirectory}/dls";
    music = "${config.home.homeDirectory}";
    pictures = "${config.home.homeDirectory}/img";
    projects = "${config.home.homeDirectory}/dev";
    publicShare = "${config.home.homeDirectory}";
    templates = "${config.home.homeDirectory}";
    videos = "${config.home.homeDirectory}";
  };

  # Start GPG agent daemon with pinentry for passphrase entry
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  services.syncthing.enable = true;

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      name = "FiraMono Nerd Font";
      size = 14.0;
    };
    keybindings = {
      "shift+enter" = "send_text all \\n";
    };
    shellIntegration.enableZshIntegration = false;
    settings = {
      tab_bar_style         = "hidden";
      filter_notification   = "all";
      enable_audio_bell     = false;
      cursor_shape          = "block";
      cursor_blink_interval = 0;
      # Dracula theme
      background        = "#282A36";
      foreground        = "#F8F8F2";
      cursor            = "#F8F8F2";
      cursor_text_color = "#282A36";
      color0  = "#21222C";
      color1  = "#FF5555";
      color2  = "#50FA7B";
      color3  = "#F1FA8C";
      color4  = "#BD93F9";
      color5  = "#FF79C6";
      color6  = "#8BE9FD";
      color7  = "#F8F8F2";
      color8  = "#6272A4";
      color9  = "#FF6E6E";
      color10 = "#69FF94";
      color11 = "#FFFFA5";
      color12 = "#D6ACFF";
      color13 = "#FF92DF";
      color14 = "#A4FFFF";
      color15 = "#FFFFFF";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "toyat522";
        email = "toyatakahashi522@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.gpg.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      python3Packages.python-lsp-server
      clang-tools
    ];

    plugins = with pkgs.vimPlugins; [
      dracula-nvim
      lualine-nvim
      barbar-nvim
      nvim-web-devicons
      gitsigns-nvim
      nvim-tree-lua
      nvim-autopairs
      nvim-treesitter.withAllGrammars
      blame-nvim
      vimtex
      blink-cmp
      friendly-snippets
      nvim-lspconfig
      telescope-nvim
      plenary-nvim
      telescope-fzf-native-nvim
    ];
  };

  programs.tmux = {
    enable = true;
    prefix = "C-a";
    keyMode = "vi";
    mouse = true;
    historyLimit = 9999999;
    escapeTime = 0;
    terminal = "tmux-256color";
    extraConfig = ''
      bind v split-window -h
      bind s split-window -v

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -T copy-mode-vi V send-keys -X begin-selection
      bind -T copy-mode-vi Y send-keys -X copy-pipe-and-cancel "wl-copy"

      unbind-key -T copy-mode-vi MouseDragEnd1Pane
      bind-key -T copy-mode-vi y send-keys -X copy-selection

      set -g xterm-keys on
    '';
  };

  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "viins";

    history = {
      size = 5000;
      save = 5000;
      path = "${config.home.homeDirectory}/.zsh_history";
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 500 ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      ''
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

        source "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.zsh"
      ''
    ];

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
    ];

    shellAliases = {
      bat = "bat -p";
      cat = "bat -p";
      ls = "eza -g --color=always";
      tks = "tmux kill-session";
      vi = "nvim";
      vim = "nvim";
    };
  };
}
