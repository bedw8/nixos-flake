
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
      ../modules/hidpi.nix
      ../modules/qt.nix
      ../modules/bluetooth.nix
      ../modules/polkit-gkring.nix
      ../modules/sound.nix
      ../modules/virt.nix
      ../modules/sus-the-hib.nix
      ../modules/keyd
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
