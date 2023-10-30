
{ config, lib, pkg, ... }:

{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

}
