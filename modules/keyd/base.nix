
{ config, lib, pkgs, user,  ... }:

{
  systemd.services.keyd = {
    description = "key remapping daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.keyd}/bin/keyd";
    };
    wantedBy = ["multi-user.target"];
  }; 

 
  users.groups.keyd = {};
  users.users.${user}.extraGroups = [ "keyd" ];

  environment.etc = {
    "keyd/default.conf" = {
      text = ''
        [ids]

        *

        [main]

        capslock = overload(nav, esc)
        esc = capslock

        leftalt = layer(meta)
        leftmeta = layer(alt)

        rightalt = overload(altgr,macro(S-f10))

        [shift]
        backspace = delete

        [altgr]
        enter = M-S-enter

        [nav:C]

        h = left
        j = down
        k = up
        l = right


      '';
      mode = "444";
    };
  };
}
