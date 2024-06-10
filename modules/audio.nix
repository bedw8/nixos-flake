
{ config, lib, pkgs, user, ... }:

{
  musnix.enable = true;
  musnix.kernel.packages = pkgs.linuxPackages_latest_rt;

  environment.systemPackages = with pkgs; [
    yabridge
    yabridgectl
    wineWowPackages.stable

    carla
    reaper
    ardour
    tenacity

    distrho
    calf
    eq10q
    lsp-plugins
    x42-plugins
    x42-gmsynth
    dragonfly-reverb
    guitarix
    FIL-plugins
    geonkick

    neural-amp-modeler-lv2
  ];

}
