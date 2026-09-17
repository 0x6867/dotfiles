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
     ../modules/nvim.nix
     ../modules/zsh.nix
   ];

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
