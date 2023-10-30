# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, inputs, pkgs, user, ... }:

{
  #imports = [ ];
  # Set your time zone.
  time.timeZone = "America/Santiago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CL.UTF-8";
    LC_IDENTIFICATION = "es_CL.UTF-8";
    LC_MEASUREMENT = "es_CL.UTF-8";
    LC_MONETARY = "es_CL.UTF-8";
    LC_NAME = "es_CL.UTF-8";
    LC_NUMERIC = "es_CL.UTF-8";
    LC_PAPER = "es_CL.UTF-8";
    LC_TELEPHONE = "es_CL.UTF-8";
    LC_TIME = "es_CL.UTF-8";
  };

  networking = {
    domain = "local"; 
    search = [ "local" ]; 
    networkmanager.enable = true;
    firewall.enable = false;
  };

  boot.kernel.sysctl."kernel.hostname" = "${config.networking.hostName}.${config.networking.domain}";

  services.xserver = {
    enable = true;
    modules = with pkgs; [ xf86_input_wacom ];
    layout = "us";
    xkbVariant = "altgr-intl";

    windowManager = {
      dwm.enable = true;
      i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
    };

    displayManager.lightdm = {
      enable = true;
      greeters.gtk.enable = true;
    };

    libinput = {
      enable = true;
      mouse.naturalScrolling = true;
      touchpad.naturalScrolling = true;
    };
    gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  };
  
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  services.gvfs.enable = true;

  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  services.flatpak.enable = true;
  services.syncthing = {
    enable = true;
    user = "${user}";
    configDir = "/home/${user}/.config/syncthing";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "input" "camera" "lp" "networkmanager" "flatpak" "docker" ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
    permittedInsecurePackages = [
      "plexamp"
      "electron-21.4.0"
      "imagemagick-6.9.12-68"
      "zotero-6.0.27"
    ];
  };

  environment = {
    variables = {
      VDPAU_DRIVER = "va_gl";
      TERMINAL = "alacritty";
      EDITOR = "vim";
      VISUAL = "vim";
    };
    systemPackages = with pkgs; [
      #vim 
      wget
      killall
      usbutils
      pciutils
      htop-vim
      ranger
      ueberzugpp
      poppler_utils
      mupdf
      alacritty
      xterm
      acpi
      tmux
    ] ++ [ xorg.libX11 xorg.libXft xorg.libXinerama xorg.libXcursor ];
  };

  programs = {
    zsh.enable = true;
    dconf.enable = true;
    seahorse.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    vim = {
      defaultEditor = true;
      package = pkgs.vim-full;
    };
  };


  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      corefonts
      liberation_ttf
      cantarell-fonts
      freefont_ttf
      fira-code
      fira-code-symbols
      source-code-pro
      ubuntu_font_family
      gnome3.adwaita-icon-theme
      google-fonts
      twitter-color-emoji
      #twemoji-color-font
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-lgc-plus
      noto-fonts-emoji
      #noto-fonts-emoji-blob-bin
      #joypixels
    ];
    
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "DejaVu Serif" "Twitter Color Emoji" ];
        sansSerif = [ "DejaVu Sans" "Twitter Color Emoji" ]; 
        monospace = [ "DejaVu Sans Mono" "Twitter Color Emoji" ]; 
        emoji = [ "Twitter Color Emoji" ];
      };
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = "experimental-features = nix-command flakes";
   };

  virtualisation.docker.enable = true;

  nixpkgs.overlays = with pkgs; [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (old: rec {
        buildInputs =  old.buildInputs ++ [ xorg.libX11 xorg.libXft xorg.libXinerama xorg.libXcursor ];
        src = ../dwm; 
       });
    })
    (self: super: {
      fcitx-engines = fcitx5;
    })
  ];

  system.stateVersion = "22.11"; 

}



