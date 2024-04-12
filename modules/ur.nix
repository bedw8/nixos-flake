
{ config, lib, pkgs, ... }:

{
  boot.kernelModules = [ "uinput" ];
  services.udev.enable = true;
  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="users", TAG+="uaccess"
  '';
}


