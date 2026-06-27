{ config, pkgs, ... }:


{
   home.username = "nixos_user";
   home.homeDirectory = "/home/nixos_user";
   programs.git.enable = true;
   home.stateVersion = "26.05";
   programs.bash = {
      enable = true;
      shellAliases = {
         btw = "echo I user nixos, btw";
      };
   };
}
