
{ lib, inputs, nixpkgs, home-manager, nur, user, ... }:

let
  system = "x86_64-linux"; 

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;

in

{
  bedwpc = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user system inputs; };
    modules = [ 
      nur.nixosModules.nur
      ./bedwpc 
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ 
          [(import ../modules/hidpi/home.nix)];
        };
      }
    ];
  };
}
