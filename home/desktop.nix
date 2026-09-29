{ config, pkgs, ... }:

{

   imports = [
     ../modules/dotfiles.nix
     ../modules/basic_security_tools.nix
     ../modules/cli_tools.nix
     #../modules/development.nix
     ../modules/communication.nix
     ../modules/media.nix
     ../modules/1password.nix
     ../modules/firefox.nix
     ../modules/nvim.nix
     ../modules/zsh.nix
     ../modules/git.nix
     ../modules/nono.nix
     ../modules/wezterm.nix
     ../modules/http_utils.nix
     ../modules/photography.nix
     ../modules/ai.nix
     ../modules/remote.nix
     # home-manager-only module: no NixOS programs.mangohud exists, so this
     # is imported here rather than from the host config. Desktop-only.
     ../modules/mangohud.nix
   ];

   # Where this repo lives on the host — target of the out-of-store symlinks
   # to config/{nvim,zsh,wezterm}. Must be absolute; see modules/dotfiles.nix.
   dotfiles.root = "/home/nixos_user/dotfiles";

   # Basic Home Manager Requirements
   home.username = "nixos_user";
   home.homeDirectory = "/home/nixos_user";
   home.stateVersion = "26.05";
   
   programs.bash = {
      enable = true;
   };

#  xdg.configFile."cosmic/com.system76.CosmicBackground/v1/all" = {
#    text = builtins.toJSON {
#     type = "Image";
#     value = "/home/nixos_user/Downloads/rose_pine.png";
#    };
# };
}
