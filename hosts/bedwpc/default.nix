
{ config, pkgs, user, ... }:

{
  imports = 
    [(import ./hardware-configuration.nix)] ++
    [(import ../configuration.nix)] ++
    [(import ../../modules/hidpi.nix)] ++
    [(import ../../modules/qt.nix)] ++
    [(import ../../modules/bluetooth.nix)] ++
    [(import ../../modules/polkit-gkring.nix)] ++
    [(import ../../modules/sound.nix)] ++
    [(import ../../modules/virt.nix)] ++
    [(import ../../modules/sus-the-hib.nix)] ++
    (import ../../modules/keyd);

  networking = {
    hostName = "bedwpc"; 
  };

  # Bootloader.
  boot = {
    loader = {
     # efi.canTouchEfiVariables = true;
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
    (import ../../modules/packages/misc.nix {pkgs=pkgs ; config=config;});
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
