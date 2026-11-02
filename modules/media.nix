{ pkgs, ... }:

{
  home.packages = [
    pkgs.sone
    pkgs.vlc
    pkgs.ffmpeg-full
  ];
}
