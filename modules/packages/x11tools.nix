{ pkgs, ... }:
with pkgs;
[
  xorg.xhost
  xorg.utilmacros
  xdragon
  xdotool
  arandr
  xorg.libXcursor
  xorg.xrandr
  xorg.xmodmap
  xorg.xkill
  xclip
]
