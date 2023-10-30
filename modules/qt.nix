{ config, pkgs, ... }:

{
  environment.variables = {
      QT_QPA_PLATFORM_PLUGIN_PATH= with pkgs; "${qt5.qtbase.bin}/lib/qt-${qt5.qtbase.version}/plugins";
  };
  environment.sessionVariables = {
      QT_QPA_PLATFORM_PLUGIN_PATH= with pkgs; "${qt5.qtbase.bin}/lib/qt-${qt5.qtbase.version}/plugins";
  };
}
