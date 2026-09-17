{ pkgs, config, libs, ...}:

{
  programs.steam = {
    enable = true;
    #remotePlay.openFirewall = true;
    #dedicatedServer.openFirewall = true;
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
}
