{ pkgs, ... }:

{
  # HTTP API clients.
  home.packages = with pkgs; [
    bruno # offline, git-friendly API client (collection files on disk)
    yaak  # desktop API client
  ];
}