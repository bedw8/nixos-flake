{ config, pkgs, ... }:

{
  environment.sessionVariables = {
      QT_ENABLE_HIGHDPI_SCALING = "0";
  };
  services.xserver.displayManager = {
    lightdm.greeters.gtk = {
      cursorTheme.size = 32;
    };
    setupCommands  = ''
      ${pkgs.xorg.xsetroot}/bin/xsetroot -xcf ${pkgs.gnome3.adwaita-icon-theme}/share/icons/Adwaita/cursors/left_ptr 32'';
    sessionCommands  = ''
      ${pkgs.xorg.xsetroot}/bin/xsetroot -xcf ${pkgs.gnome3.adwaita-icon-theme}/share/icons/Adwaita/cursors/left_ptr 32'';
  };
}
