{ pkgs, ... }:

{
  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # To be able to set fish as default shell
  programs.fish.enable = true;

  # Create users folder
  users.users.fester = {
    isNormalUser = true;
    createHome = true;
    home = "/home/fester";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.fish;
    hashedPassword = "$6$tJ5uhL9I4svKLCc.$jVbz85zl2z5zvpFydzGRLPHxcByJUGq5FEXUcfuktDS428XIg9xAfxThKCrhA/e31eCMQh8X4KMUiKgPtyZYy.";
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILRsXI5a6WLD6eflNESoq41hjyrsn6ySCe6qKD2m1CvyAAAABHNzaDo= fester@maccie.lan"
    ];
  };
}