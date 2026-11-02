{ pkgs, ... }:

{
  # Flatpak + Flathub.
  #
  # In this nixpkgs (26.05) services.flatpak exposes only `enable` and
  # `package` — there is no declarative `remotes`/`packages` option, so the
  # flathub remote is added by the oneshot below.
  #
  # Enabling flatpak alone fails evaluation: services.flatpak.enable asserts
  # that xdg.portal.enable is true, and xdg.portal.enable asserts that
  # extraPortals is non-empty. All three pieces are mandatory.
  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      # Native COSMIC backend (both hosts run COSMIC).
      pkgs.xdg-desktop-portal-cosmic
      # Fallback for interfaces the cosmic backend does not implement.
      pkgs.xdg-desktop-portal-gtk
    ];
    # xdg-desktop-portal 1.17+ reworked backend loading and needs an explicit
    # choice; "*" keeps the older "first implementation found" behaviour.
    # Tighten to [ "cosmic" "gtk" ] once the backend name is confirmed on the
    # host.
    config.common.default = "*";
  };

  # No declarative flathub remote in this release — add it idempotently.
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub \
        https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };
}