{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.uxplay;
  cliOptions = "${lib.optionalString (cfg.name != null) "-n ${cfg.name}"} ${lib.optionalString (! cfg.includeHost) "-nh"}";
in {
  options = {
    programs.uxplay = with lib; {
      enable = mkEnableOption "ghostty";
      pkg = mkOption {
        type = types.package;
        default = pkgs.uxplay;
        description = "The uxplay package to use";
      };
      name = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The name of the uxplay server";
      };
      includeHost = mkOption {
        type = types.bool;
        default = true;
        description = "If the host should be included in the name";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services = {
      "uxplay" = {
        Unit = {
          Description = "Uxplay AirPlay server";
        };
        Service = {
          Type = "simple";
          ExecStart = "${cfg.pkg}/bin/uxplay ${cliOptions}";
        };
        Install.WantedBy = ["default.target"];
      };
    };
  };
}
