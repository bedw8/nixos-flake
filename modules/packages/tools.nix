{ pkgs, ... }:
with pkgs;
[ 
  ripgrep
  #ripgrep-all
  playerctl
  fd
  bat
  gnome.zenity
  gnome.vinagre
  appimage-run
  unrar
  unzip
  zip
  unar
  ffmpeg
  wirelesstools
  pdf2svg
  desktop-file-utils
  gh
]
