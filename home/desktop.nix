{ config, pkgs, ... }:


{
   # Basic Home Manager Requirements
   home.username = "nixos_user";
   home.homeDirectory = "/home/nixos_user";
   home.stateVersion = "26.05";
   
   home.packages = [
      pkgs.discord-ptb
      pkgs._1password-cli
      pkgs._1password-gui
   ];

   programs.git.enable = true;
   programs.bash = {
      enable = true;
      shellAliases = {
         btw = "echo I user nixos, btw";
      };
   };
}
