{ config, pkgs, ... }:

{

   imports = [
     ../modules/basic_security_tools.nix
     ../modules/cli_tools.nix
     #../modules/development.nix
     ../modules/communication.nix
     ../modules/media.nix
     ../modules/1password.nix
     ../modules/firefox.nix
   ];

   # Basic Home Manager Requirements
   home.username = "nixos_user";
   home.homeDirectory = "/home/nixos_user";
   home.stateVersion = "26.05";
   
   programs.git = {
      enable = true;
      settings.user.name = "0x6867";
      settings.user.email = "1156977+0x6867@users.noreply.github.com";
   };


   programs.gh =  {
     enable = true;
     gitCredentialHelper = {
       enable = true;
    }; 
   };

   programs.bash = {
      enable = true;
      shellAliases = {
         btw = "echo I user nixos, btw";
      };
   };

  # Enable Neovim and set as default text editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    #plugins:
    #plugins = with pkgs.vimPlugins;
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

  xdg.configFile."cosmic/com.system76.CosmicBackground/v1/all" = {
    text = builtins.toJSON {
     type = "Image";
     value = "/home/nixos_user/Downloads/rose_pine.png";
    };
 };


  #programs.sone.enable = true;
}
