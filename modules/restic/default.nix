{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.aus.programs.restic;
  localIncludeFile = pkgs.writeTextFile {
    name = "local-include";
    text = lib.concatStringsSep "\n" cfg.local.include;
  };
  localExcludeFile = pkgs.writeTextFile {
    name = "local-exclude";
    text = lib.concatStringsSep "\n" cfg.local.exclude;
  };
  offsiteIncludeFile = pkgs.writeTextFile {
    name = "offsite-include";
    text = lib.concatStringsSep "\n" cfg.offsite.include;
  };
  offsiteExcludeFile = pkgs.writeTextFile {
    name = "offsite-exclude";
    text = lib.concatStringsSep "\n" cfg.offsite.exclude;
  };

  resticLocal =
    if cfg.local.enable
    then
      pkgs.scripts.restic_backup {
        password-file = cfg.local.password_file;
        repository-location = cfg.local.repo_location;
        include = localIncludeFile;
        exclude = localExcludeFile;
      }
    else null;
  resticOffsite =
    if cfg.offsite.enable
    then
      pkgs.scripts.restic_offsite {
        password-file = cfg.offsite.password_file;
        repository-location = cfg.offsite.repo_location;
        include = offsiteIncludeFile;
        exclude = offsiteExcludeFile;
      }
    else null;
in {
  options = {
    aus.programs.restic = {
      local = {
        enable = lib.mkEnableOption "Enable local backups";
        password_file = lib.mkOption {
          type = lib.types.str;
          description = "Location of the password file for the local backup repository";
        };
        repo_location = lib.mkOption {
          type = lib.types.str;
          description = "Location of the local backup repository";
        };
        include = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "List of directories to include in the backup";
        };
        exclude = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "List of directories to exclude from the backup";
        };
        schedule = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Systemd onCalendar schedule for the backup";
        };
      };

      offsite = {
        enable = lib.mkEnableOption "Enable offsite backups";
        password_file = lib.mkOption {
          type = lib.types.str;
          description = "Location of the password file for the local backup repository";
        };
        repo_location = lib.mkOption {
          type = lib.types.str;
          description = "Location of the offsite backup repository";
        };
        include = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "List of directories to include in the backup";
        };
        exclude = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "List of directories to exclude from the backup";
        };
        schedule = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Systemd onCalendar schedule for the backup";
        };
      };
    };
  };

  config = {
    home.packages =
      []
      ++ (
        if cfg.local.enable
        then [resticLocal]
        else []
      )
      ++ (
        if cfg.offsite.enable
        then [resticOffsite]
        else []
      );

    # Systemd services
    systemd.user.services = {
      "restic-backup" = lib.mkIf (cfg.local.schedule != null) {
        Unit = {
          Description = "Restic backup";
          After = ["sops-nix.service"];
        };
        Service = {
          ExecStart = "${resticLocal}/bin/restic_backup auto-backup";
          WorkingDirectory = config.aus.home;
          StandardOutput = "append:/tmp/restic-backup.log";
        };
      };
      "restic-offsite" = lib.mkIf (cfg.offsite.schedule != null) {
        Unit = {
          Description = "Restic offsite backup";
          After = ["sops-nix.service"];
        };
        Service = {
          ExecStart = "${resticOffsite}/bin/restic_offsite backup";
          WorkingDirectory = config.aus.home;
          StandardOutput = "append:/tmp/restic-offsite.log";
        };
      };
    };

    systemd.user.timers = {
      "restic-backup" = lib.mkIf (cfg.local.schedule != null) {
        Unit = {
          Description = "Automatic restic backup";
        };
        Timer = {
          OnCalendar = cfg.local.schedule;
          Persistent = false;
        };
        Install.WantedBy = ["timers.target"];
      };
      "restic-offsite" = lib.mkIf (cfg.offsite.schedule != null) {
        Unit = {
          Description = "Automatic offsite restic backup";
        };
        Timer = {
          OnCalendar = cfg.offsite.schedule;
          Persistent = false;
        };
        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
