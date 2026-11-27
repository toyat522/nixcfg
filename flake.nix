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

  outputs = { self, nixpkgs, home-manager, nixgl, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      mkNixos = host: nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/${host}
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.toyat = import ./hosts/${host}/home.nix;
          }
        ];
      };
      mkHome = system: modules: home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs system;
        modules = [ ./platforms/generic-linux.nix ] ++ modules;
      };
      nixGL = driver: import ./platforms/nixgl.nix {
        pkgs = mkPkgs "x86_64-linux";
        inherit nixgl driver;
      };
      genericIdentity = { ... }: let username = builtins.getEnv "USER"; in {
        home.username = username;
        home.homeDirectory = "/home/${username}";
      };
    in {
      nixosConfigurations = {
        aomori = mkNixos "aomori";
        hague = mkNixos "hague";
      };

      packages = forAllSystems (system: let pkgs = mkPkgs system; in {
        zsh = import ./packages/shell { inherit pkgs; };
        neovim = import ./packages/neovim { inherit pkgs; };
        tmux = import ./packages/tmux { inherit pkgs; };
        oriedita = pkgs.callPackage ./packages/oriedita.nix { };
      });

      apps = forAllSystems (system: {
        zsh = {
          type = "app";
          meta.description = "Configured Zsh shell with personal CLI tools";
          program = "${self.packages.${system}.zsh}/bin/nixcfg-zsh";
        };
      });

      homeConfigurations = {
        work-laptop = mkHome "x86_64-linux" [ ./hosts/work-laptop/home.nix (nixGL "nvidia") ];
        intel = mkHome "x86_64-linux" [ ./hosts/generic-linux/home.nix genericIdentity (nixGL "intel") ];
        nvidia = mkHome "x86_64-linux" [ ./hosts/generic-linux/home.nix genericIdentity (nixGL "nvidia") ];
        jetson = mkHome "aarch64-linux" [ ./hosts/generic-linux/home.nix genericIdentity ];
      };
    };
}
