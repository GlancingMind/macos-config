{pkgs, ...}: {
  programs.home-manager.enable = true;

  home = {
    homeDirectory = "/Users/sascha";
    stateVersion = "24.05";
  };

  xdg = {
    enable = true;
  };

  programs.vscode = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    smartmontools
    unzip zip
    poppler_utils pandoc texlive.combined.scheme-small #for pandoc
    fd
    xdg-ninja
    (pkgs.writeShellApplication {
      name = "connect-to-thm-vpn";
      runtimeInputs = [pkgs.openconnect];
      text = ''
        printf "Enter your login name: "
        read -r username

        printf "Password: "
        stty -echo
        read -r password
        stty echo

        printf "\n"

        echo "$password" | sudo openconnect -u "$username" --passwd-on-stdin vpn.thm.de
      '';
    })
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.zsh.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    signing = {
      # Signing key for my public commits and repos.
      key = "0x6958F57B10911518";
    };
    delta = {
      enable = true;
      options = {
        syntax-theme="gruvbox-light";
      };
    };
    extraConfig = {
      pull.ff = "only";
      init.defaultBranch = "main";
    };
  };
}
