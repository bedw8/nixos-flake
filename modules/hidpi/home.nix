{ config, pkgs, ... }:
{
  xresources.extraConfig = builtins.readFile (./.Xresources);
  home = {
    pointerCursor = {
      package = pkgs.gnome3.adwaita-icon-theme;
      name = "Adwaita";
      size = 32;
      x11.enable = true; 
      gtk.enable = true;
    };

    sessionVariables = {
      QT_ENABLE_HIGHDPI_SCALING = "0";
    };
  };

}
