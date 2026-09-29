{ pkgs, ... }:

{
  # Install only — no configuration is managed here.
  #
  # nono is a sandboxing tool, and the intent is to keep its configuration
  # external (it was previously under config/nono, which has been removed).
  # It is installed on both Linux hosts; nothing in this repo drives it.
  home.packages = [ pkgs.nono ];
}