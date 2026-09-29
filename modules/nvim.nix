{ config, pkgs, ... }:

{

  # Enable Neovim and set as default text editor
  #programs.neovim = {
    #enable = true;
    #defaultEditor = true;
    #viAlias = true;
    #vimAlias = true;
    # extraLuaConfig = builtins.readFile "../config/nvim/init.lua"; 
    # `initLua` and `sideloadInitLua` are deliberately left unset: the
    # external config below owns init.lua, and setting either option would
    # make home-manager write into ~/.config/nvim on top of the symlink.

    #plugins:
    #plugins = with pkgs.vimPlugins;
  #};
  
  home.packages = [ pkgs.neovim ];

  # Live, out-of-store symlink so config/nvim/init.lua and basic/*.lua are
  # read from the repo checkout and stay editable without a rebuild.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.root}/config/nvim";

}
