{ pkgs, lib, ... }:

let
  default-shell = pkgs.bashInteractive;
  configureBash = true;
  configureZsh = true;
in {
  imports = [
    ./prompt.nix
    ./readline.nix
    ./bash.nix
    ./zsh.nix
  ];

  home.sessionVariables = {
    SHELL = lib.getExe default-shell;
  };

  programs.starship.enable = true;

  programs.bash.enable = configureBash;
  programs.starship.enableBashIntegration = configureBash;

  programs.zsh.enable = configureZsh;
  programs.starship.enableZshIntegration = configureZsh;

  programs.zoxide = {
    enable = true;
    enableBashIntegration = configureBash;
    enableZshIntegration = configureZsh;
  };

  home.shellAliases = let
    fd = lib.getExe pkgs.fd;
    fzy = lib.getExe pkgs.fzy;
  in {
    jd = ''
      function jumpToDir() {
        cd $(${fd} --type directory | ${fzy} --lines=15 --query=$1)
      };
      jumpToDir
    '';
    open = ''
      function openIn() {
        "$1" $(${fd} --type file | ${fzy} --lines=15)
      };
      openIn
    '';
    sf = ''
      function selectFile() {
        ${fd} --type file | ${fzy} --lines=15 --query=$1
      };
      selectFile
    '';
  };
}
