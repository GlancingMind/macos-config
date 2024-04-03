{ pkgs, inputs,...}: {
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;
  
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  
  programs.zsh.enable = true;  # default shell on catalina
  
  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  
  environment.systemPackages = let
    rebuild-system = pkgs.writeShellScriptBin "rebuild-system.sh" ''
      darwin-rebuild switch --flake "/Users/sascha/workspace/os-config/flake.nix";
    '';
  in [ 
    rebuild-system
  ];
}
