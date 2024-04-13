{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-aerospace = {
      url = "github:nikitabobko/aerospace";
      flake = false;
    };
    homebrew-loop = {
      url = "github:mrkai77/loop";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nix-darwin, nix-homebrew, home-manager, nixpkgs,...}@inputs:
  let
    hostname = "MacBook-Air-von-Sascha";
  in {
    darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        nix-homebrew.darwinModules.nix-homebrew
        { # nix-homebrew configuration
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "sascha";
            taps = {
              #"homebrew/homebrew-core" = inputs.homebrew-core;
              #"homebrew/homebrew-cask" = inputs.homebrew-cask;
              #"homebrew/homebrew-bundle" = inputs.homebrew-bundle;
              #"nikitabobko/tap/aerospace" = inputs.homebrew-aerospace;
              #"mrkai77/cask/loop" = inputs.homebrew-loop;
            };
            mutableTaps = true;
          };
        }
        ./configuration.nix
        home-manager.darwinModules.home-manager
      ];
      specialArgs = { inherit inputs; };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."${hostname}".pkgs;
  };
}
