{pkgs, lib, inputs, ...}: {
  imports = [
    ./modules/shell
  ];

  programs.home-manager.enable = true;

  nix = {
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
    };
  };

  home = {
    homeDirectory = "/Users/sascha";
    stateVersion = "24.11";
    sessionVariables = {
      EDITOR = lib.getExe pkgs.neovim;
      VISUAL = lib.getExe pkgs.neovim;
    };
  };

  xdg = {
    enable = true;
  };

  programs.vscode = {
  #  enable = true;
  };

  home.packages = with pkgs; [
    nodejs
    pandoc
    ollama
    # vagrant
    carlito # font used for enterprise architect
    yt-dlp
    smartmontools
    unzip zip
    poppler_utils pandoc texlive.combined.scheme-small #for pandoc
    ripgrep fd
    xdg-ninja
    klog-time-tracker
    libgen-cli
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
    (pkgs.writeShellApplication {
      # username: re351san
      name = "connect-to-htwg-vpn";
      runtimeInputs = [pkgs.openvpn];
      text = let
        config = fetchurl {
          url = "https://www.htwg-konstanz.de/fileadmin/pub/ou/rz/VPN/HTWG-MFA-SOSE25-STUD.ovpn";
          sha256 = "1zdlwqy4jhymhwb3kn9qnmg2fl11jcb4jgagvsfmqzkpz7xiyki2";
        };
      in ''
        printf "Enter your login name: "
        read -r username

        printf "Password: "
        stty -echo
        read -r password
        stty echo

        printf "\n"

        sudo openvpn --config ${config} --auth-user-pass <(echo -e "$username\n$password")
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

  programs.mpv = {
    enable = true;
    config = {
      #NOTE use the more frequently updated yt-dlp instead of youtube-dl to
      # circumvent throtteling issues.
      script-opts="ytdl_hook-ytdl_path=${lib.getExe pkgs.yt-dlp}";
    };
    profiles = {
      "youtube-1080p" = {
        ytdl-format="bestvideo[height<=?1080]+bestaudio/best";
      };
      "youtube-720p" = {
        ytdl-format="bestvideo[height<=?720]+bestaudio/best";
      };
      "youtube-480p" = {
        ytdl-format="bestvideo[height<=?480]+bestaudio/best";
      };
      "youtube-360p" = {
        ytdl-format="bestvideo[height<=?360]+bestaudio/best";
      };
    };
  };
}
