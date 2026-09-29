{ pkgs, ... }:

{
  # Remote desktop.
  #
  # rustdesk-flutter is the current build (the plain `rustdesk` attribute is
  # the older/unmaintained one). It is AGPL-3.0, which is a free licence, so
  # it needs no unfree exception.
  home.packages = [ pkgs.rustdesk-flutter ];
}