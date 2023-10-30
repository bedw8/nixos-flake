{ pkgs, ... }:
with pkgs;
[
  # launcher
  rofi
  rofi-power-menu

  # browser
  brave

  # uti
  zathura
  sioyek
  evince


  # viewers  
  feh
  mpv
  vlc

  # office
  onlyoffice-bin

  # misc libs
  libnotify
  gdb
  glib
  libsecret
]
