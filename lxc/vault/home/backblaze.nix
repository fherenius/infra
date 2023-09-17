{ pkgs, ...}:

{
  home.packages = with pkgs; [
    backblaze-b2
  ];

  # Service to run a sync to backblaze
  systemd.user.services = {
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

  # Timer to run a backup daily
  systemd.user.timers = {
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