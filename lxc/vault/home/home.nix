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
  home.file.".config/vault-agent/config.hcl" = {
    enable = true;
    executable = false;
    source = ./vault-agent-config.hcl;
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
    backblaze = {
      Unit = {
        Description = "Backup of the Vault Data";
      };
      Service = {
        ExecStart = "/etc/profiles/per-user/vault/bin/backblaze-b2 sync --noProgress --compareVersions modTime --incrementalMode ./data b2://keipi-vault-backup";   
        WorkingDirectory = "~";
        EnvironmentFile = "/home/vault/.backblaze-env";
      };
    };
  };

  # Timers to run
  systemd.user.timers = {
    vault-agent = {
      Unit = {
        Description = "Run daily Vault Agent to update files";
      };
      Timer = {
        OnCalendar = "daily";
      };
    };
    backblaze = {
      Unit = {
        Description = "Runs the daily backup of Vault";
        After = [ "vault-agent.timer" ];
      };
      Timer = {
        OnCalendar = "daily";
      };
    };
  };
}