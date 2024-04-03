{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = github:nix-community/NUR;
    nixvim.url = github:nix-community/nixvim;
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

  };
  
  outputs = { self, nixpkgs, home-manager, nur, nixvim, ... }@inputs: 
  let
    system = "x86_64-linux";
    user = "bedw";
    pkgs = nixpkgs.legacyPackages.${system};
    hmconf = home-manager.lib.homeManagerConfiguration;
  in 
  {
    nixosConfigurations = (
      import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs user system home-manager nur nixvim;
      }
    );

    homeConfigurations = {
      "bedw@bedwpc" = hmconf {
        inherit pkgs;
        extraSpecialArgs = { inherit user; };
        modules = [
          nixvim.homeManagerModules.nixvim
          ./hosts/home.nix
          ./modules/hidpi/home.nix
        ];
      };
    };
  };
}

