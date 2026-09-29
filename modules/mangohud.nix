{ pkgs, config, libs, ...}:

{
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
