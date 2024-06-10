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
    videoDrivers = [ "intel" ];
    deviceSection = ''
      Option "DRI" "2"
      Option "TearFree" "true"
    '';

    xkb = {
      layout = "us";
      variant = "altgr-intl";
    };

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
    config.common.default = "*";
  };

  services.gvfs.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  services.unbound.enable = true;

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
    #ignoreShellProgramCheck = true;
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
    permittedInsecurePackages = [
      "plexamp"
      "electron-25.9.0"
      "imagemagick-6.9.12-68"
      "zotero-6.0.27"
    ];
    zathura = {useMupdf = false;};
  };

  environment = {
    variables = {
      VDPAU_DRIVER = "va_gl";
      TERMINAL = "alacritty";
      NIXPKGS_ALLOW_UNFREE = "1";
      #EDITOR = "vim";
      #VISUAL = "vim";
    };
    systemPackages = with pkgs; [
      #vim 
      git
      gnupg
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
      xdg-user-dirs
      home-manager
    ] ++ [ xorg.libX11 xorg.libXft xorg.libXinerama xorg.libXcursor ];

    etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;
  };

  programs = {
    zsh.enable = true;
    dconf.enable = true;
    nix-ld.enable = true;
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
      fira-code-symbols
      source-code-pro
      gnome3.adwaita-icon-theme
      google-fonts
      twitter-color-emoji
      #twemoji-color-font
      #noto-fonts
      #noto-fonts-cjk-sans
      #noto-fonts-cjk-serif
      #noto-fonts-lgc-plus
      #noto-fonts-emoji
      (nerdfonts.override { fonts = [ 
        "FiraCode"
        "DroidSansMono" 
        "UbuntuMono"
        "Ubuntu"
        "Noto"
      ]; })

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
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = ["root" "${user}"];
    };
  };

  virtualisation.docker.enable = true;
  hardware.keyboard.qmk.enable = true;

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



