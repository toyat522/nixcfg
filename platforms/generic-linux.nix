{ ... }:

{
  targets.genericLinux.enable = true;
  nixpkgs.overlays = [
    (_: prev: {
      obsidian = prev.obsidian.override { commandLineArgs = "--no-sandbox"; };
    })
  ];
}
