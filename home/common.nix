{ config, pkgs, lib, ... }:

{
  home.stateVersion = "26.05";

  home.packages = (import ./headless.nix pkgs) ++ (with pkgs; [
    firefox
    sxiv
  ]);

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

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
      shell                 = "${pkgs.zsh}/bin/zsh --login";
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

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Toya Takahashi";
        email = "toyatakahashi522@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.gpg.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = import ./nvim/plugins.nix pkgs;
  };

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux/tmux.conf;
  };

  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
    };
  };

  programs.zsh =
    let zshRc = import ./zsh.nix { inherit pkgs; };
    in {
      enable = true;
      enableCompletion = false;
      initContent = lib.mkMerge [
        (lib.mkOrder 500 zshRc.instantPrompt)
        zshRc.body
      ];
    };
}
