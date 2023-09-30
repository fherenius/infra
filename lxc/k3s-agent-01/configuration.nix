{ pkgs, modulesPath, ...}:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  system.stateVersion = "23.05";
  time.timeZone = "Europe/Amsterdam";

  # Enable Flakes and the new CLI
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # Environment pkgs
  environment.systemPackages = with pkgs; [
    git # Used by Flake
    k3s # Point of this server
  ];

  # Disable for multinode k3s support
  # See: https://nixos.wiki/wiki/K3s#Multi-node_setup
  networking.firewall = {
    enable = false;
  };

  # K3s setup
  services.k3s = {
    enable = true;
    role = "agent"; # Run this node as server
  };

  environment.etc = {
    # K3s config file
    "rancher/k3s/config.yaml" = {
      mode = "0400";
      text = ''        
        token: "agent-token"
        egress-selector-mode: "cluster"
        server: "192.168.1.220"
      '';
    };
  };
}