{ config, pkgs, ... }:

{
  # Package only. `programs.wezterm` writes wezterm/wezterm.lua only when
  # `settings` is non-empty or `extraConfig` is set, so leaving both unset
  # keeps home-manager from fighting with the symlinked config below.
  programs.wezterm.enable = true;

  # The real config lives in the repo (config/wezterm/wezterm.lua) and is
  # symlinked live, so its macOS-oriented keybinds stay editable in place.
  xdg.configFile."wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.root}/config/wezterm";
}