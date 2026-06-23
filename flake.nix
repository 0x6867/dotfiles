{
   description = "NixOS First Flake";	
   inputs = {
      nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
      home-manager = {
      	url = "github:nix-community/home-manager/release-26.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };
   };

   outputs = { self, nixpkgs, home-manager, ... }@attrs: {
      nixosConfigurations.desktop-nix = nixpkgs.lib.nixosSystem {
         system = "x86_64-linux";
         specialArgs = attrs;
         modules = [
            ./configuration.nix
	    home-manager.nixosModules.home-manager {
            home-manager = {
	       useGlobalPkgs = true;
               useUserPackages = true;
	       users.hemish = import ./home.nix;
	       backupFileExtension = "backup";
	       };
            }
         ];
      };
   };
}
