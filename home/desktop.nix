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
      pkgs.sone
      #pkgs.obsidian
      pkgs.vlc
      pkgs.gh
   ];

   programs.git = {
      enable = true;
      userName = "0x6867;";
      userEmail = "1156977+0x6867@users.noreply.github.com";
   };
   programs.bash = {
      enable = true;
      shellAliases = {
         btw = "echo I user nixos, btw";
      };
   };


   programs.mangohud = {
    enable = true;
    enableSessionWide = false; # Adds MangoHud to your environment variables
    settings = {
      fps = true;
      cpu_stats = true;
     gpu_stats = true;
    };
   };

  #programs.sone.enable = true;
}
