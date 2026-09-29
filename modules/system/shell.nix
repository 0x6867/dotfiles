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
  };

  # Make zsh the login shell for nixos_user.
  #
  # `programs.zsh.enable` adds pkgs.zsh to environment.shells, which is what
  # writes /etc/shells; this line selects it for the account. Both are needed:
  # without the environment.shells entry, chsh would reject the path.
  users.users.nixos_user.shell = pkgs.zsh;
}