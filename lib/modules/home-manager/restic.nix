{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.aus.programs.restic;

  resticType = lib.types.submodule {
    options = {
      enable = lib.mkEnableOption "Enable";
      password_file = lib.mkOption {
        type = lib.types.str;
        description = "Location of the password file for the backup repository";
      };
      repo_location = lib.mkOption {
        type = lib.types.str;
        description = "Location of the backup repository";
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
        description = "Systemd OnCalendar schedule for the backup";
      };
      exclude-if-present = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "List of files to exclude if present in the backup directory";
      };
      forget = lib.mkOption {
        type = lib.types.attrsOf lib.types.int;
        default = {};
        description = "List of forget options";
      };
      skip-verify-repo = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Skip repository verification";
      };
    };
  };

  buildRestic = name: restic_cfg: let
    localIncludeFile = pkgs.writeTextFile {
      name = "local-include";
      text = lib.concatStringsSep "\n" restic_cfg.include;
    };
    localExcludeFile = pkgs.writeTextFile {
      name = "local-exclude";
      text = lib.concatStringsSep "\n" restic_cfg.exclude;
    };
  in
    pkgs.scripts.restic_backup {
      name = "restic_${name}";
      password-file = restic_cfg.password_file;
      repository-location = restic_cfg.repo_location;
      include = localIncludeFile;
      exclude = localExcludeFile;
      forget = restic_cfg.forget;
      exclude-if-present = restic_cfg.exclude-if-present;
      skip-verify-repo = restic_cfg.skip-verify-repo;
    };

  packages = lib.mapAttrs buildRestic (lib.filterAttrs (name: val: val.enable) cfg);

  buildService = name: _: {
    Unit = {
      Description = "Restic ${name} backup";
      After = ["sops-nix.service"];
    };
    Service = {
      ExecStart = "${packages.${name}}/bin/restic_${name} backup";
    };
  };

  buildTimer = name: restic_cfg: {
    Unit = {
      Description = "Automatic restic ${name} backup";
    };
    Timer = {
      OnCalendar = restic_cfg.schedule;
      Persistent = false;
    };
    Install.WantedBy = ["timers.target"];
  };

  timers = lib.attrsets.mapAttrs' (name: value: lib.attrsets.nameValuePair "restic-${name}" (buildTimer name value)) (lib.filterAttrs (name: val: val.schedule != null && val.enable) cfg);
  services = lib.attrsets.mapAttrs' (name: value: lib.attrsets.nameValuePair "restic-${name}" (buildService name value)) (lib.filterAttrs (name: val: val.schedule != null && val.enable) cfg);
in {
  options = {
    aus.programs.restic = lib.mkOption {
      default = {};
      type = lib.types.attrsOf resticType;
      description = "A list of restic backup configurations";
    };
  };

  config = {
    home.packages = lib.attrValues packages;
    systemd.user.services = services;
    systemd.user.timers = timers;
  };
}
