{ pkgs, modulesPath, ...}:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  # Enable Flakes and the new CLI
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Environment seggints
  environment.systemPackages = with pkgs; [
    git # Used by Flake
  ];
  time.timeZone = "Europe/Amsterdam";

  # Add version of Nix that the host is running
  system.stateVersion = "23.05";

  # Services setup
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = false;
      PasswordAuthentication = false;
    };
  };

  # Ensure Vault can be reached from outside
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8200 ];
  };

  # Config the Vault user
  users.users.vault = {
    uid = 1000;
    createHome = true;
    group = "vault";
    home = "/home/vault";
    isNormalUser = true; 
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILRsXI5a6WLD6eflNESoq41hjyrsn6ySCe6qKD2m1CvyAAAABHNzaDo= fester@maccie.lan"
    ];
  };

  # Create group
  users.groups.vault = {
    members = [ "vault" ];
  };


  # Allow user systemd services to run in between restarts without having to login
  systemd.tmpfiles.rules = [
    "f /var/lib/systemd/linger/vault"
  ];
}