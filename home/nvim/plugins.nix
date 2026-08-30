# Neovim plugin list, shared by the Home Manager config (home/common.nix) and the
# standalone devShell (flake.nix). Kept in one place so the two never drift.
pkgs: with pkgs.vimPlugins; [
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
]
