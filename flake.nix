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

  outputs = { nixpkgs, home-manager, nixgl, ... }:
  let
    # Extra Home Manager configuration for non-NixOS systems
    mkPkgs = system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-x86     = mkPkgs "x86_64-linux";
    pkgs-aarch64 = mkPkgs "aarch64-linux";

    # nixGL passes `kernel = null` to nvidia-x11, an arg nixpkgs-26.05 removed, so
    # strip that dead line and build nixGL from the patched source
    nixgl-x86 =
      let
        src = pkgs-x86.runCommand "nixgl-patched" { } ''
          cp -r ${nixgl} $out
          chmod -R +w $out
          substituteInPlace $out/nixGL.nix --replace-fail "kernel = null;" ""
        '';
      in pkgs-x86.callPackage "${src}/nixGL.nix" { };

    # nixGL's own auto-detection can't parse new open-kernel driver strings, so
    # detect the version ourselves.
    nvidiaVersion =
      let
        verFile = pkgs-x86.runCommand "nvidia-version" {
          time = builtins.currentTime;
          preferLocalBuild = true;
          allowSubstitutes = false;
        } "grep -oE '[0-9]+\\.[0-9]+(\\.[0-9]+)?' /proc/driver/nvidia/version | head -1 > $out";
      in pkgs-x86.lib.trim (builtins.readFile verFile);

    mkGnome = pkgs: extraModules:
      let username = builtins.getEnv "USER";
      in home-manager.lib.homeManagerConfiguration {
        # Fix Electron SUID sandbox issue on non-NixOS distros
        pkgs = pkgs.extend (_: prev: {
          obsidian = prev.obsidian.override { commandLineArgs = "--no-sandbox"; };
        });
        modules = [
          ./home/gnome-full.nix

          # Allows Home Manager configuration to run properly for non-NixOS distros
          { targets.genericLinux.enable = true; }

          {
            home.username = username;
            home.homeDirectory = "/home/${username}";
          }

        ] ++ extraModules;
      };

    # Wrap kitty with nixGL to solve the OpenGL problem on non-NixOS distros
    nixGLKittyModule = nixglPkg: nixglBin: ({ pkgs, ... }: {
      programs.kitty.package = pkgs.symlinkJoin {
        name = "kitty";
        paths = [
          (pkgs.writeShellScriptBin "kitty" ''
            exec ${nixglPkg}/bin/${nixglBin} ${pkgs.kitty}/bin/kitty "$@"
          '')
          pkgs.kitty
        ];
      };
    });
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

    # Enter devshell with `nix develop -c zsh`
    devShells = {
      x86_64-linux.default  = import ./home/devshell.nix { pkgs = pkgs-x86; };
      aarch64-linux.default = import ./home/devshell.nix { pkgs = pkgs-aarch64; };
    };

    # Switch configuration with `home-manager switch --flake .#<config>`
    homeConfigurations = {
      intel  = mkGnome pkgs-x86 [ (nixGLKittyModule nixgl-x86.nixGLIntel "nixGLIntel") ];
      nvidia = mkGnome pkgs-x86 [ (nixGLKittyModule (nixgl-x86.nvidiaPackages { version = nvidiaVersion; }).nixGLNvidia "nixGLNvidia-${nvidiaVersion}") ];
      jetson = mkGnome pkgs-aarch64 [];
    };
  };
}
