
{ lib, inputs, nixpkgs, system, user, ... }:
let
  home-manager = inputs.home-manager;
  nur = inputs.nur;
  nixvim = inputs.nixvim;

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
      nixvim.nixosModules.nixvim
      ./bedwpc 
      #home-manager.nixosModules.home-manager {
      #  home-manager.useGlobalPkgs = true;
      #  home-manager.useUserPackages = true;
      #  home-manager.extraSpecialArgs = { inherit user; };
      #  home-manager.users.${user} = import ./home.nix;
      #}
      ../modules/hidpi.nix
      ../modules/qt.nix
      ../modules/bluetooth.nix
      ../modules/polkit-gkring.nix
      ../modules/sound.nix
      ../modules/virt.nix
      ../modules/sus-the-hib.nix
      ../modules/keyd
    ];
  };
}
