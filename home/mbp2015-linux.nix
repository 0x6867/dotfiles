{ config, pkgs, ... }:

{
   imports = [
     ../modules/basic_security_tools.nix
     # ../modules/cli_tools.nix   # does not exist yet — see agents.md
     ../modules/communication.nix
     ../modules/media.nix
     ../modules/1password.nix
     ../modules/firefox.nix
     ../modules/nvim.nix
     ../modules/zsh.nix
     ../modules/git.nix
   ];

   # Basic Home Manager Requirements
   home.username = "nixos_user";
   home.homeDirectory = "/home/nixos_user";
   home.stateVersion = "26.05";

   programs.bash = {
      enable = true;
   };
}
