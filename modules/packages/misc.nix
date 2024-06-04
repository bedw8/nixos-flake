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
  (pdfpc.overrideAttrs (prev: {
      src = pkgs.fetchFromGitHub {
        owner = "pdfpc";
        repo =  "pdfpc";
        rev = "4b5060fbd46ebfe115665c614dfee3eeaf51fbd0";
        hash = "sha256-8zuG6Pg4BTYAlSBDbwuvPLG0hj6XREeSwfI2kisKc4M=";
      };
      patches = [ ];
    })
  )
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
