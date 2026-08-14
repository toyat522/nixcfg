{
  description = "Nix and Home Manager configuration for toyat522";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs = inputs@{ nixpkgs, home-manager, nixgl, ... }:
  let
    # Extra Home Manager configuration for non-NixOS systems
    mkPkgs = system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-x86     = mkPkgs "x86_64-linux";
    pkgs-aarch64 = mkPkgs "aarch64-linux";

    mkGnome = pkgs: nixglPkg: nixglBin: home-manager.lib.homeManagerConfiguration {
      # Fix Electron SUID sandbox issue on non-NixOS distros
      pkgs = pkgs.extend (_: prev: {
        obsidian = prev.obsidian.override { commandLineArgs = "--no-sandbox"; };
      });
      modules = [
        ./home/gnome-full.nix

        # Allows Home Manager configuration to run properly for non-NixOS distros
        { targets.genericLinux.enable = true; }

        # Solve the "OpenGL" problem for kitty on non-NixOS distros
        ({ pkgs, ... }: {
          programs.kitty.package = pkgs.symlinkJoin {
            name = "kitty";
            paths = [
              (pkgs.writeShellScriptBin "kitty" ''
                exec ${nixglPkg}/bin/${nixglBin} ${pkgs.kitty}/bin/kitty "$@"
              '')
              pkgs.kitty
            ];
          };
        })
      ];
    };
  in {
    # Switch configuration with `sudo nixos-rebuild switch --flake .#<hostname>`
    nixosConfigurations = {
      aomori = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/aomori

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.toyat = import ./home/sway-full.nix;
          }
        ];
      };
      hague = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/hague

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.toyat = import ./home/sway-full.nix;
          }
        ];
      };
    };

    # Switch configuration with `home-manager switch --flake .#<config> --impure`
    homeConfigurations = {
      toyat-intel          = mkGnome pkgs-x86    nixgl.packages.x86_64-linux.nixGLIntel    "nixGLIntel";
      toyat-nvidia         = mkGnome pkgs-x86    nixgl.packages.x86_64-linux.nixGLNvidia   "nixGLNvidia";
      toyat-nvidia-aarch64 = mkGnome pkgs-aarch64 nixgl.packages.aarch64-linux.nixGLNvidia "nixGLNvidia";
    };
  };
}
