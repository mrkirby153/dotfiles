{
  pkgs,
  lib,
  config,
  ...
}: {
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
  };

  config = lib.mkIf config.aus.programs.download-reaper.enable {
    systemd.user.services = {
      "download-reaper" = {
        Unit = {
          Description = "Clean up downloads";
        };
        Service = {
          Type = "oneshot";
          ExecStart = let
            download_reaper = pkgs.scripts.download_reaper rec {
              target_path = config.aus.programs.download-reaper.target_path;
              holding_path_root = config.aus.programs.download-reaper.destination_path;
              holding_path_fallback = "${target_path}/.stale";
            };
          in "${download_reaper}/bin/download_reaper";
        };
      };
    };
    systemd.user.timers = {
      "download-reaper" = {
        Unit = {
          Description = "Clean up downloads";
        };
        Timer = {
          OnCalendar = config.aus.programs.download-reaper.frequency;
          Persistent = true;
        };
        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
