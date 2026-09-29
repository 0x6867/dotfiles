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
  # ~/.zshenv is the one file zsh reads before it picks $ZDOTDIR, so this is
  # where ZDOTDIR has to be set. It is written by home-manager (not symlinked),
  # which is why it lives at $HOME rather than inside the symlinked directory.

  home.file.".zshenv".text = ''
    # Managed by home-manager — points zsh at the dotfiles repo.
    export ZDOTDIR="${config.home.homeDirectory}/.config/zsh"
  '';

  # Live, out-of-store symlink to the working copy, so edits to the repo apply
  # without a rebuild. mkOutOfStoreSymlink is only a symlink to the path string
  # it is given, hence the absolute dotfiles.root.
  xdg.configFile."zsh".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.root}/config/zsh";
}