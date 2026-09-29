{ pkgs, ... }:

{
  # Image editing / RAW processing.
  home.packages = with pkgs; [
    gimp     # raster image editor
    rapidraw # RAW photo editor
  ];
}