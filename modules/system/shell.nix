{ pkgs, ... }:

{
  # System-side zsh registration. The user's shell configuration itself is
  # external (config/zsh/, symlinked by modules/zsh.nix); this module only
  # makes zsh a first-class system shell.
  programs.zsh = {
    enable = true;

    # config/zsh/.zshrc already runs `compinit` with a custom zcompdump path.
    # The generated /etc/zshrc would otherwise run compinit a second time.
    enableGlobalCompInit = false;

    # Relocate the entire zsh config directory to ~/.config/zsh.
    #
    # /etc/zshenv (which this option writes into) is read BEFORE zsh picks any
    # user startup file, so this is the only place ZDOTDIR can be set and still
    # make zsh look in $ZDOTDIR for .zshenv itself. Setting it from
    # ~/.zshenv is too late: zsh has already chosen $HOME/.zshenv, reads that
    # one, and then never reads $ZDOTDIR/.zshenv at all.
    #
    # Consequence: nothing zsh-related needs to live in $HOME. zsh reads
    # ~/.config/zsh/.zshenv (the repo file, via the modules/zsh.nix symlink)
    # exactly once. Mirrors radleylewis/zsh setup step 2.
    shellInit = ''
      if [[ -z "$XDG_CONFIG_HOME" ]]; then
        export XDG_CONFIG_HOME="$HOME/.config"
      fi
      if [[ -d "$XDG_CONFIG_HOME/zsh" ]]; then
        export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
      fi
    '';
  };

  # Make zsh the login shell for nixos_user.
  #
  # `programs.zsh.enable` adds pkgs.zsh to environment.shells, which is what
  # writes /etc/shells; this line selects it for the account. Both are needed:
  # without the environment.shells entry, chsh would reject the path.
  users.users.nixos_user.shell = pkgs.zsh;
}