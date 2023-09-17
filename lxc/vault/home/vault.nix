{ pkgs, ... }:

{
  home.packages = with pkgs; [
    vault-bin
  ];

  # Include config file
    home.file.".config/vault/config.hcl" = {
    enable = true;
    executable = false;
    source = ./vault-config.hcl;
  };

  # Service for running vault
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