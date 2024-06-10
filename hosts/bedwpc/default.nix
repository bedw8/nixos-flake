
{ config, pkgs, user, ... }:

{
  imports = 
    [
      ./hardware-configuration.nix
      ../configuration.nix
      ./disk-config.nix 
      ../../modules/audio.nix
    ];

  networking = {
    hostName = "bedwpc"; 
  };

  # Bootloader.
  boot = {
    loader = {
      efi.efiSysMountPoint = "/boot";
      grub = {
        enable = true;

        efiSupport = true;
        efiInstallAsRemovable = true;
        devices = [ "nodev" ];
      };
    };
    #kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "resume_offset=8022016" ];
    resumeDevice = "/dev/pool/root";
    extraModprobeConfig = "options snd-hda-intel model=alc255-acer,dell-headset-multi";
  };


  environment = {
    systemPackages =  
    (import ../../modules/packages/wm_essentials.nix pkgs) ++
    (import ../../modules/packages/tools.nix pkgs) ++
    (import ../../modules/packages/x11tools.nix pkgs) ++
    (import ../../modules/packages/programming.nix pkgs) ++
    (import ../../modules/packages/misc.nix {
      inherit pkgs;
      inherit config;
      }
    );
  };


  hardware.acpilight.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [ 
      vaapiIntel
      libvdpau-va-gl
      intel-media-driver
    ];
  };

  services.openssh.enable = true;
  services.upower.enable = true;
  services.auto-cpufreq.enable = true;
}
