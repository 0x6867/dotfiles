{ pkgs, ... }:

{
  home.packages = [
    pkgs._1password-cli # unfree
    pkgs._1password-gui # unfree
  ];
}
