{ config, pkgs, lib, ... }:

# Define custom packages
let
  oriedita = pkgs.callPackage ./pkgs/oriedita.nix { };
in

{
  home.username = "toyat";
  home.homeDirectory = "/home/toyat";

  # Home Manager release that is compatible with this configuration
  home.stateVersion = "26.05";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Install Nix packages into the environment
  home.packages = with pkgs; [
    bat
    claude-code
    cmake
    eza
    fastfetch
    fd
    firefox
    gcc
    gnumake
    htop
    nerd-fonts.fira-mono
    obsidian
    oriedita
    python3
    ranger
    ripgrep
    sxiv
    texlive.combined.scheme-medium
    thunderbird
    unzip
  ];

  # Append to PATH
  home.sessionPath = [ "$HOME/.local/bin" ];

  # Manage environment variables
  home.sessionVariables = { };

  # Create symlinks to ~/
  home.file = {
  };

  # Create symlinks to ~/.config
  xdg.configFile = {
    "nvim/init.lua".source = ./nvim/init.lua;
    "nvim/lua".source = ./nvim/lua;
    "nvim/ftplugin".source = ./nvim/ftplugin;
  };

  # Set XDG directories
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
    videos = "${config.home.homeDirectory}/img";
  };

  # Set default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf"        = "org.pwmt.zathura-pdf-mupdf.desktop";
      "text/html"              = "firefox.desktop";
      "x-scheme-handler/http"  = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };

  # Write to dconf configuration system for GNOME
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:swapescape" ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Enable systemd services
  services.syncthing.enable = true;

  # Japanese input via fcitx5 + mozc
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
      settings = {
        globalOptions = {
          "Hotkey/TriggerKeys" = {
            "0" = "Control+space";
            "1" = "Zenkaku_Hankaku";
          };
        };
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "mozc";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "mozc";
        };
      };
    };
  };

  # Remove the fcitx UI
  systemd.user.services.fcitx5-daemon.Service.ExecStart = lib.mkForce
    "${config.i18n.inputMethod.fcitx5.fcitx5-with-addons.override { addons = config.i18n.inputMethod.fcitx5.addons; }}/bin/fcitx5 --disable classicui";

  # Allow font configuration
  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  programs.tmux = {
    enable = true;
    prefix = "C-a";
    keyMode = "vi";
    mouse = true;
    historyLimit = 9999999;
    escapeTime = 0;
    terminal = "tmux-256color";
    extraConfig = ''
      # Split panes using 's' and 'v'
      bind v split-window -h
      bind s split-window -v

      # Switch panes using hjkl
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Copy to system clipboard
      bind -T copy-mode-vi V send-keys -X begin-selection
      bind -T copy-mode-vi Y send-keys -X copy-pipe-and-cancel "wl-copy"

      # Don't scroll all the way down on copy
      unbind-key -T copy-mode-vi MouseDragEnd1Pane
      bind-key -T copy-mode-vi y send-keys -X copy-selection
    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 14.0;
        normal = {
          family = "FiraMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "FiraMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "FiraMono Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "FiraMono Nerd Font";
          style = "Bold Italic";
        };
      };
      keyboard.bindings = [
        {
          key = "Return";
          mods = "Shift";
          chars = "\n";
        }
      ];
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
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

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      python3Packages.python-lsp-server
      clang-tools
    ];

    plugins = with pkgs.vimPlugins; [
      sonokai
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

  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      sandbox = "none";
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
    defaultKeymap = "viins"; # vim keybindings

    history = {
      size = 5000;
      save = 5000;
      path = "${config.home.homeDirectory}/.zsh_history";
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };

    initContent = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

      source "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.zsh"
    '';

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
      ls = "eza --color=always";
      tks = "tmux kill-session";
      vi = "nvim";
      vim = "nvim";
    };
  };
}
