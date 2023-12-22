
{ config, lib, pkgs, user,  ... }:

{
  systemd.services.keyd = {
    description = "key remapping daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.keyd}/bin/keyd";
    };
    wantedBy = ["multi-user.target"];
    restartIfChanged = true;
  }; 

 
  users.groups.keyd = {};
  users.users.${user}.extraGroups = [ "keyd" ];

  environment.etc = {
    "keyd/default.conf" = {
      source = ./keyd.conf ;
      mode = "444";
    };
  };
}
