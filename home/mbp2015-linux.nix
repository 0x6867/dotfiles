{ config, pkgs, ... }:

{
   imports = [
     ../modules/dotfiles.nix
     ../modules/basic_security_tools.nix
     ../modules/cli_tools.nix
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
     # modules/mangohud.nix is intentionally NOT imported here: Mangohud is
     # desktop-only (it belongs with modules/steam.nix's scope).
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
}
