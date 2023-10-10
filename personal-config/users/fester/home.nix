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

  
 wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "alacritty"; 
      startup = [
        # Launch Firefox on start
        {command = "firefox";}
      ];
    };
  };
}