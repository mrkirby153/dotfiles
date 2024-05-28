{
  pkgs,
  lib,
  config,
  ...
}: let
  shellScript = import ../../lib/shellScript.nix {
    inherit (pkgs) writeTextFile runtimeShell;
    inherit pkgs lib;
  };
  nix_index_updater = shellScript {
    name = "nix-index-updater";
    path = ./scripts/nix_index_update;
    deps = with pkgs; [
      jq
      curl
      coreutils
    ];
  };
in {
  config = lib.mkIf config.aus.programs.shell.enable {
    programs.nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

    systemd.user.services = {
      "nix-index-update" = {
        Unit = {
          Description = "Updates the nix-index";
        };
        Service = {
          Type = "oneshot";
          ExecStart = lib.getExe nix_index_updater;
        };
      };
    };

    systemd.user.timers = {
      "nix-index-update" = {
        Unit = {
          Description = "Updates the nix-index";
        };
        Timer = {
          OnCalendar = "Sun *-*-* 00:00:00";
          Persistent = true;
          Unit = "nix-index-update.service";
        };
        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
