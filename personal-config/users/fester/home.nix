{ lib, config, pkgs, ... }:

{
  # Version of Nix
  home.stateVersion = "23.05";

  # Packages to install
  home.packages = with pkgs; [
    alacritty
    bat
    fd
    fzf
    ripgrep
    helix
    exa
    lazygit
    firefox
    zathura
  ];

  # Environment variables
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "helix";
    PAGER = "less -FirSwX";
    BROWSER = "firefox";
  };

  # Fish setup
  programs.fish = {
    enable = true;
  };

  # Copy config files
  xdg.configFile = {
    "alacritty/alacritty.yml" = {
      source = ./alacritty.yml;
    };
  };

  xresources.extraConfig = builtins.readFile ./Xresources;

  xsession.windowManager.i3 = {
    enable = true;
  };
  
  # Wayland config
  #wayland.windowManager.sway = {
  #  enable = true;
  #  config = {
  #    modifier = "Mod4";
  #    # Use kitty as default terminal
  #    terminal = "alacritty"; 
  #    output = {
  #      Virtual-1 = {
  #        mode = "1920x1200@59.885Hz";
  #        scale = "1.25";
  #      };
  #    };
  #  };
  #};
}