{ ... }:
{
  programs.starship = {
    settings = {
      add_newline = false;
      battery.disabled = true;
      cmake.disabled = true;
      cmd_duration.disabled = true;
      git_status.disabled = true;
      jobs = {
        number_threshold = 1;
        symbol_threshold = 1;
      };
      line_break.disabled = true;
      package.disabled = true;
    };
  };
}
