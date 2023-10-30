{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = github:nix-community/NUR;
    };

  };
  
  outputs = inputs @ { self, nixpkgs, home-manager, nur, ... }: 
  let
    system = "x86_64-linux";
    user = "bedw";
  in 
  {
    nixosConfigurations = (
      import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs user system home-manager nur;
      }
    );
  };
}

