{ config, ... }:
{
  programs.readline = {
    enable = true;
    includeSystemConfig = true;
    variables = {
      editing-mode = "vi";

      # Completion settings
      show-all-if-ambiguous = true;
      completion-ignore-case = true;

      # Preffyfi
      colored-stats = true;
      colored-completion-prefix = true;
    };
    extraConfig = ''
      Control-l: clear-screen
    '';
  };

  home.sessionVariables = {
    INPUTRC="${config.xdg.dataHome}/readline/inputrc";
  };
}
