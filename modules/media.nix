{ pkgs, ... }:

{
  home.packages = [
    pkgs.sone
    pkgs.vlc
  ];
}
