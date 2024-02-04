
{ config, lib, pkgs, user, ...}:

{
  #imports = 
  #  [(import ../hosts/home.nix)] ++
  #  (import ../modules/services);

  home = {
    username = "${user}";
    sessionVariables = {
        EDITOR = "vim";
        VISUAL = "vim";
    };
    #homeDirectory = "/home/${user}";

    packages = with pkgs; [ ];
    stateVersion = "22.11";
  };

  xsession.enable=true;

  gtk.enable = true;
  #nixpkgs.config = {
  #  allowUnfree = true;
  #  allowUnfreePredicate = (_: true);
  #};

  #programs.zsh.enable = true;
  programs.home-manager.enable = true;
  programs.git = {
      enable = true;
      userName = "Benjamin Edwards";
      userEmail = "bedw@bedw.me";
  };
  programs.lf.enable = true;
  programs.nix-index = {
    enable = true;
    enableZshIntegration = true; 
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.rofi = {
    enable = true;
    plugins = with pkgs; [ rofi-emoji ];
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = "Monokai";
    extraConfig = {
      modi = "drun,emoji,ssh";
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
        dmenu = "/run/current-system/sw/bin/rofi -dmenu -p dmenu";
        browser = "/run/current-system/sw/bin/brave";
      };
      urgency_normal = {
        timeout = 3;
      };
    };
  };

  services.picom = {
    enable = true;
    vSync = true;
    fade = true;
    fadeDelta = 5;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
  };

  services.caffeine.enable=true;

  services.dwm-status = {
    enable = true;
    order = [ "time" "backlight" "audio" "battery" ];
  };
  systemd.user.services.dwm-status.Service = {
    Restart = "on-failure";
    RestartSec = 1;
  };

  services.blueman-applet.enable = true;
  services.network-manager-applet.enable = true;
    
}
