{ config, pkgs, ... }:


{
   home.username = "hemish";
   home.homeDirectory = "/home/hemish";
   programs.git.enable = true;
   home.stateVersion = "26.05";
   programs.bash = {
      enable = true;
      shellAliases = {
         btw = "echo I user nixos, btw";
      };
   };
}
