pkgs: with pkgs; [
  bat
  clang-tools
  cmake
  eza
  fastfetch
  fd
  file
  fzf
  gcc
  git
  gnumake
  htop
  nerd-fonts.fira-mono
  (python3.withPackages (ps: [ ps.python-lsp-server ps.termcolor ]))
  ripgrep
  screen
  tcpdump
  tmuxp
  unzip
  usbutils
  yazi
  zip
  zoxide
]
