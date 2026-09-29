{ lib, ... }:

{
  options.dotfiles.root = lib.mkOption {
    type = lib.types.str;
    description = ''
      Absolute path to this dotfiles repository on the machine being
      configured.

      This is the target of the out-of-store symlinks that point
      `~/.config/{nvim,zsh,wezterm}` at `config/{nvim,zsh,wezterm}` inside
      the repository, so the live working copy is what the tools read.

      It must be absolute. `config.lib.file.mkOutOfStoreSymlink` merely
      creates a symlink to the string it is given, so a relative path (or a
      bare `./config`) would resolve against the *store copy* of the repo
      rather than the checkout, silently pointing at frozen files.

      There is deliberately no default: a wrong or missing value produces a
      dangling symlink that still builds successfully, so each host must
      state this explicitly.
    '';
    example = "/home/nixos_user/dotfiles";
  };
}