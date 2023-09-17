{ lib, config, pkgs, ... }:

{
  home.username = "vault";
  home.homeDirectory = lib.mkForce "/home/vault";

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;

  imports = [
    ./vault.nix
    ./vault-agent.nix
    ./backblaze.nix
  ];
}