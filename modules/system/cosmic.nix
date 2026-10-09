{ config, lib, pkgs, ... }:

{
  # Enable the COSMIC desktop environment and greeter
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  services.system76-scheduler.enable = true;

  # Optional: Enable Flatpak support through COSMIC Store
  #services.flatpak.enable = true;

  # Optional: Additional COSMIC-related packages or tools
  environment.systemPackages = with pkgs; [
    # Add any extra tools or packages you want alongside COSMIC
    cosmic-ext-calendar
  ];
}
