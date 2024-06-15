
{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [ linuxPackages.usbip ];
  boot.initrd.availableKernelModules = [ "vhci-hcd" ];

}
