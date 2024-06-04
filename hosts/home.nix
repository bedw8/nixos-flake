
{ config, lib, pkgs, user, ...}:

{
  imports = [ ../modules/nixvim.nix ];

  home = {
    username = "${user}";
    sessionVariables = {
        EDITOR = lib.mkForce "vim";
        VISUAL = "vim";
    };
    homeDirectory = "/home/${user}";

    packages = with pkgs; [ ];
    stateVersion = "22.11";
  };


  gtk.enable = true;
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  programs.zsh = {
    enable = true;
    initExtra = ''
      fpath+="${pkgs.script-directory}/share/zsh/site-functions"

      # Conda fix
      . ~/.conda/etc/profile.d/conda.sh
      '';
    defaultKeymap = "emacs";
    oh-my-zsh = let
      pi-themes = pkgs.fetchFromGitHub {
        owner = "tobyjamesthomas";
        repo = "pi";
        rev = "96778f903b79212ac87f706cfc345dd07ea8dc85";
        hash = "sha256-P2Q5BUNot1j/vP7nYVj7SQ8TRqXSRxdk86xQDOMNUn4=";
      };
      customDir = pkgs.stdenv.mkDerivation {
        name = "oh-my-zsh-custom-dir";
        phases = [ "buildPhase" ];
        buildPhase = ''
            mkdir -p $out/themes
            cp ${pi-themes}/*.zsh-theme $out/themes/
        '';
      };
    in 
    {
      enable = true;
      custom = "${customDir}";
      theme = "pi";
      plugins = [ 
      "sudo"
      "z" 
      "command-not-found"
      "cp" 
      "extract"
      "jump"
      "themes"
      "vi-mode"
      "direnv"
      "common-aliases" ];
    };
    plugins = [
      #{
      #  name = "zsh-vim-mode";
      #  file = "zsh-vim-mode.plugin.zsh";
      #  src = pkgs.fetchFromGitHub {
      #    owner = "softmoth";
      #    repo = "zsh-vim-mode";
      #    rev = "1f9953b7d6f2f0a8d2cb8e8977baa48278a31eab";
      #    sha256 = "sha256-a+6EWMRY1c1HQpNtJf5InCzU7/RphZjimLdXIXbO6cQ=";
      #  };
      #}
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
  };

  programs.home-manager.enable = true;
  programs.git = {
      enable = true;
      userName = "Benjamin Edwards";
      userEmail = "bedw@bedw.me";
  };

  programs.lf = let
      ctpv = "${pkgs.ctpv}/bin";
    in {
      enable = true;
      previewer.source = "${ctpv}/ctpv";
      settings = {
        autoquit = true;
        cleaner = "${ctpv}/ctpvclear";
        dircache = true;
        drawbox = true;
        globsearch = true;
        icons = true;
        incfilter = true;
        number = true;
        relativenumber = true;
        shell = "${pkgs.zsh}/bin/zsh";
        shellopts = "-eu";
        tabstop = 4;
        wrapscroll = true;
      };

      extraConfig = ''
        &${ctpv}/ctpv -s $id
        &${ctpv}/ctpvquit $id
      '';
  };


  programs.nix-index = {
    enable = true;
    enableZshIntegration = true; 
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true; 
    nix-direnv.enable = true;
  };

  #programs.starship = {
  #  enable = true;
  #  enableZshIntegration = true;
  #  settings = {
  #    character = {
  #      success_symbol = "[π](bold green)";
  #      error_symbol = "[π](bold red)";
  #    };
  #    nodejs.disabled = true;
  #  };
  #};

  programs.fzf = {
    enable = true;
    #enableZshIntegration = true;
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

  programs.script-directory = {
    enable = true;
    settings = {
      SD_ROOT = "${config.home.homeDirectory}/Documents/scripts";
    };
  };

  xsession.enable=true;
  services.dunst = {
    enable = true;
    settings = {
      global = {
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
        dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dmenu";
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

  #services.caffeine.enable=true;

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
