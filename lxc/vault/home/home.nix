{ config, pkgs, ... }:

{
  home.username = "vault";
  home.homeDirectory = "/home/vault";

  home.packages = with pkgs; [
    vault-bin
  ];

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}