{ lib, config, pkgs, ... }:

{
  home.username = "vault";
  home.homeDirectory = lib.mkForce "/home/vault";

  home.packages = with pkgs; [
    vault-bin
    backblaze-b2
  ];

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;

  # Included files
  home.file.".config/vault/config.hcl" = {
    enable = true;
    executable = false;
    source = ./vault-config.hcl;
  };
  home.file."backblaze_env" = {
    enable = true;
    executable = false;
    source = config.lib.file.mkOutOfStoreSymlink ./secrets/backblaze_env;
  };
  
  # Programs to run at startup
  systemd.user.services = {
    vault = {
      Unit = {
        Description = "Runs a Vault instance";
      };
      Service = {
        ExecStart = "/etc/profiles/per-user/vault/bin/vault server -config /home/vault/.config/vault/config.hcl";
        ExecReload = "/bin/kill -HUP $MAINPID";
        WorkingDirectory = "~";
        Restart = "always";
        KillSignal = "SIGTERM";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}