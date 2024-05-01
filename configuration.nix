{ pkgs, lib, inputs,...}: 

let
  homebrew = import ./brew.nix;
in {
  inherit homebrew;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfreePredicate = let
    unfreePackagesNames = import ./unfree-package-names.nix;
  in pkg: builtins.elem (lib.getName pkg) unfreePackagesNames;
  
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      # Allow to build and run x86_64 binaries via rosetta.
      # Make sure to have rosetta installed: softwareupdate --install-rosetta --agree-to-license
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

    settings = {
      # Necessary for using flakes on this system.
      experimental-features = "nix-command flakes";

      # Enable sandboxing for nixpkg contribution
      sandbox = true;
      # Hardlink identical files together
      auto-optimise-store = true;
    };
  };
  
  programs.zsh.enable = true;  # default shell on catalina
  
  environment.systemPackages = let
    rebuild-system = pkgs.writeShellScriptBin "rebuild-system.sh" ''
      darwin-rebuild switch --flake /Users/sascha/workspace/os-config/flake.nix
    '';
  in [ 
    rebuild-system
  ];

  security.pam.enableSudoTouchIdAuth = true;

  users.users.sascha.home = "/Users/sascha";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.sascha = import ./home.nix;
  };
  
  environment.pathsToLink = [
    "/share/zsh"
    "/share/bash-completions"
  ];

  system.defaults = {
    # disable popup for selection of accent characters on keyrepeat
    NSGlobalDomain.ApplePressAndHoldEnabled = false;
    
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
  };
}
