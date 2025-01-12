{
  pkgs,
  lib,
  config,
  aus,
  ...
}: let
  cfg = config.aus.programs.download-reaper;
  downloadReaper = aus.lib.shellScript {
    name = "download_reaper";
    path = ./download_reaper;
    deps = with pkgs; [
      rsync
      libnotify
      findutils
      gawk
    ];
    env = {
      TARGET_PATH = cfg.target_path;
      HOLDING_PATH_ROOT = cfg.destination_path;
      HOLDING_PATH_FALLBACK = "${cfg.target_path}/.stale";
    };
  };
in {
  options.aus.programs.download-reaper = {
    enable = lib.mkEnableOption "Enable download reaper";
    frequency = lib.mkOption {
      type = lib.types.str;
      default = "Sat *-*-* 13:30:00";
      description = "systemd calendar expression for when to run the download reaper";
    };
    target_path = lib.mkOption {
      type = lib.types.str;
      description = "Path to clean up";
    };
    destination_path = lib.mkOption {
      type = lib.types.str;
      description = "Path to move files to";
    };
    pkg = lib.mkOption {
      type = lib.types.pkgs;
      default = downloadReaper;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services = {
      "download-reaper" = {
        Unit = {
          Description = "Clean up downloads";
        };
        Service = {
          Type = "oneshot";
          ExecStart = lib.getExe downloadReaper;
        };
      };
    };
    systemd.user.timers = {
      "download-reaper" = {
        Unit = {
          Description = "Clean up downloads";
        };
        Timer = {
          OnCalendar = cfg.frequency;
          Persistent = true;
        };
        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
