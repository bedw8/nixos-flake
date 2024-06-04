
{ config, pkgs, user, ... }:

{
  imports = 
    [(import ./hardware-configuration.nix)] ++
    [(import ../configuration.nix)];

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
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "resume_offset=18542592" ];
    resumeDevice = "/dev/nvme0n1p4";
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
      mesa_drivers
      mesa
    ];
    driSupport = true;
    driSupport32Bit = true;
  };

  services.openssh.enable = true;
  services.upower.enable = true;
  services.auto-cpufreq.enable = true;
}
