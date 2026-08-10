
{ inputs, pkgs, config, ... }:

{
  programs.firefox = {
    enable = true;
    
    profiles.default = {
    	id = 0;
	name = "Default";
	settings = {
		# browser settings go here
	};
	extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
		ublock-origin
		foxyproxy-standard
		pwnfox
		1password
		sponsorblock
		darkreader
	];
    };
  };
}
