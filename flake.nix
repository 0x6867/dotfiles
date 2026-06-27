{
   description = "NixOS First Flake";	
   inputs = {
      nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
      home-manager = {
      	url = "github:nix-community/home-manager/release-26.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      disko = {
         url = "github:nix-community/disko";
         inputs.nixpkgs.follows = "nixpkgs";
      };
   };

   outputs = { self, nixpkgs, home-manager, disko,... } {
      nixosConfigurations = {
         desktop-nix = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
               disko.nixosModules.disko
               ./hosts/desktop/configuration.nix
	       home-manager.nixosModules.home-manager {
               home-manager = {
	          useGlobalPkgs = true;
                  useUserPackages = true;
	          users.nixos_user = import ./home/desktop.nix;
	          backupFileExtension = "backup";
	          };
               }
            };
         ];
      };
   };
}
