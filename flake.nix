{
   # Description
   description = "NixOS First Flake";	

   # Inputs for flake
   inputs = {
      # Official NixOS, Darwin, HM Package Sources
      # Source Packages
      nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";

      # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
      # nixos-hardware.url = "github:nixos/nixos-hardware"

      # Home manager
      home-manager = {
      	url = "github:nix-community/home-manager/release-26.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };


      # Utilities
      # Disko for declaritive partioning and formatting
      disko = {
         url = "github:nix-community/disko";
         inputs.nixpkgs.follows = "nixpkgs";
      };
     
      # nix-index-database 
      nix-index-database = {
        url = "github:nix-community/nix-index-database";
        inputs.nixpkgs.follows = "nixpkgs";
      };

     sopsnix = {
        url = "github:mic92/sops-nix";
        inputs.nixpkgs.follows = "nixpkgs";
     };



     #Private Repositories
     
   };

   outputs = { self, nixpkgs, home-manager, disko, ... }: {
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
            ];
         };
      };
   };
}
