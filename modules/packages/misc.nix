{ pkgs, config, ... }:
with pkgs;
[
  #gtk3
  #gtkd
  pandoc
  cairo # 
  android-tools
  inkscape
  spotify
  zoom-us
  obsidian
  plexamp
  tdesktop
  zotero
  cloudflared
  ppp
  openfortivpn
  yt-dlp
  xournalpp
  rmview
  remarkable-mouse
  pdfpc
  fastfetch
  gephi
  aircrack-ng
  auto-cpufreq
  cpufrequtils
  #(appimageTools.wrapType2
  #{
  #  # or wrapType1
  #  name = "Beeper";
  #  src = fetchurl {
  #    url = "https://download.beeper.com/linux/appImage/x64";
  #    sha256 = "sha256-Xw1C4AA1/PkgJKYUghGx03ATU9pHb7zxwfArd2eQ9Pw=";
  #  };
  #})
]
