{ pkgs, ... }:

{
  home.packages = [
    pkgs.nmap
    pkgs.wireshark 
    pkgs.caido-desktop #unfree
    pkgs.burpsuite #unfree
    pkgs.hashcat-utils
  ];
}

