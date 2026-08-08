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
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
    mkGnome = nixglPkg: nixglBin: home-manager.lib.homeManagerConfiguration {
      # Fix Electron SUID sandbox issue on non-NixOS distros
      pkgs = pkgs.extend (_: prev: {
        obsidian = prev.obsidian.override { commandLineArgs = "--no-sandbox"; };
      });
      modules = [
        ./home/gnome-full.nix

        # Allows Home Manager configuration to run properly for non-NixOS distros
        { targets.genericLinux.enable = true; }

        # Solve the "OpenGL" problem for alacritty on non-NixOS distros
        ({ pkgs, ... }: {
          programs.alacritty.package = pkgs.symlinkJoin {
            name = "alacritty";
            paths = [
              (pkgs.writeShellScriptBin "alacritty" ''
                exec ${nixglPkg}/bin/${nixglBin} ${pkgs.alacritty}/bin/alacritty "$@"
              '')
              pkgs.alacritty
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
    };

    # Switch configuration with `home-manager switch --flake .#<config>`
    homeConfigurations = {
      toyat-intel  = mkGnome nixgl.packages.x86_64-linux.nixGLIntel  "nixGLIntel";
      toyat-nvidia = mkGnome nixgl.packages.x86_64-linux.nixGLNvidia "nixGLNvidia";
    };
  };
}
