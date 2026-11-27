{ pkgs }:

pkgs.neovim.override {
  configure = {
    customRC = ''
      lua vim.g.nixcfg_pylsp = "${pkgs.python3Packages.python-lsp-server}/bin/pylsp"
      lua vim.g.nixcfg_clangd = "${pkgs.clang-tools}/bin/clangd"
      lua vim.opt.runtimepath:prepend("${./.}")
      luafile ${./init.lua}
    '';
    packages.nixcfg.start = import ./plugins.nix pkgs;
  };
}
