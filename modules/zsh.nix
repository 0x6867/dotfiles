{ config, pkgs, ... }:

{
  home.packages = [ pkgs.zsh ];

  # Four notes on why this module does NOT enable home-manager's programs.zsh:
  #
  # 1. programs.zsh always writes `${dotDir}/.zshenv` and `${dotDir}/.zshrc`,
  #    regardless of whether any content was configured. With xdg.enable left
  #    at its (false) default, dotDir is $HOME, so it would write ~/.zshenv and
  #    ~/.zshrc — and it would write *through* the symlinked ~/.config/zsh
  #    directory below, modifying files in the repo.
  # 2. The external config in config/zsh/ already owns compinit, so the NixOS
  #    `programs.zsh.enableGlobalCompInit` is turned off in
  #    modules/system/shell.nix to avoid a second compinit in /etc/zshrc.
  # 3. Registering zsh in /etc/shells is a system concern, handled by
  #    modules/system/shell.nix.
  # 4. Installing pkgs.zsh here gives the user a zsh on PATH even before the
  #    system module is imported (e.g. in a home-manager-only build).
  #
  # ZDOTDIR is set system-wide in modules/system/shell.nix
  # (`programs.zsh.shellInit`, which lands in /etc/zshenv). That file is read
  # before zsh picks any user startup file, so zsh goes straight to
  # ~/.config/zsh/.zshenv and reads it exactly once.
  #
  # Do NOT reintroduce a ~/.zshenv here. A file at $HOME/.zshenv is what zsh
  # reads first, and it then *shadows* the repo's config/zsh/.zshenv — zsh
  # never reads $ZDOTDIR/.zshenv as well. That was the original bug:
  # XDG_STATE_HOME went unset, so HISTFILE became "/zsh/history" and no
  # history was ever saved.

  # zsh does not create parent directories for HISTFILE or for the compinit
  # dump, so a missing directory means history is silently never written.
  # Mirrors radleylewis/zsh setup step 4.
  xdg.stateFile."zsh/.keep".text = "";
  xdg.cacheFile."zsh/.keep".text = "";

  # Live, out-of-store symlink to the working copy, so edits to the repo apply
  # without a rebuild. mkOutOfStoreSymlink is only a symlink to the path string
  # it is given, hence the absolute dotfiles.root.
  xdg.configFile."zsh".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.root}/config/zsh";
}
