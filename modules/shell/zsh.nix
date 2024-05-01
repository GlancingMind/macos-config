{ pkgs, ... }:
{
  programs.zsh = {
    defaultKeymap = "viins";
    # grml zsh overrides viins setting, need to apply it again after sourcing gmrl
    initExtraBeforeCompInit = ''
      source ${pkgs.grml-zsh-config}/etc/zsh/zshrc
      bindkey -v

      # Move zcompdump into xdg-cache directory
      compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

    '';
      #export HISTFILE = "$XDG_STATE_HOME/zsh/history";
    dotDir = ".config/zsh";
    enableCompletion = true;
  };
}
