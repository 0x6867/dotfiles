
{ pkgs, ... }:

{

  # Enable Neovim and set as default text editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    #plugins:
    #plugins = with pkgs.vimPlugins;
  };

}
