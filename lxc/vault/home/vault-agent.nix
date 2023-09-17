{  ... }:

{
  # Include config
  home.file.".config/vault-agent/config.hcl" = {
    enable = true;
    executable = false;
    source = ./vault-agent-config.hcl;
  };

  # Service to run Vault Agent
  systemd.user.services = {
    vault-agent = {
      Unit = {
        Description = "Runs a Vault Agent instance";
        After = [ "vault.service" ];
      };
      Service = {
        ExecStart = "/etc/profiles/per-user/vault/bin/vault agent -config /home/vault/.config/vault-agent/config.hcl";
        WorkingDirectory = "~";
      };
    };
  };

  # Timer to periodically update credentials
  systemd.user.timers = {
    vault-agent = {
      Unit = {
        Description = "Run daily Vault Agent to update files";
      };
      Timer = {
        OnCalendar = "daily";
      };
    };
  };
}