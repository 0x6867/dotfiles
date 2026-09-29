{ ... }:

{
    # home-manager-only module: there is no NixOS `programs.mangohud`, so this
    # is imported from home/desktop.nix rather than from the host config.
    #
    # Desktop-only: it is not imported by home/mbp2015-linux.nix, and the
    # desktop host additionally sets MANGOHUD_CONFIG=no_display in
    # hosts/desktop/configuration.nix so the overlay is opt-in per game.
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