{ inputs, pkgs, config, ... }:
let
  # Check about:support for exension/addon ID strings.
  extensions = [
    "uBlock0@raymondhill.net"  # uBlock Origin
    "{d634138d-c276-4fc8-924b-40a0ea21d284}" #1password
    "addon@darkreader.org" #darkreader
    "foxyproxy@eric.h.jung" #foxyproxy
    "sponsorBlocker@ajay.app" #sponsorblock
  ];
in
{
  programs.firefox = {
    enable = true;
    
    #Check about:policies#documentation for options
    policies = {
      ExtensionSettings = builtins.listToAttrs (builtins.map (id: {
      name = id;
      value = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
        installation_mode = "force_installed";
      };
      }) extensions);
    };
  };
}
