{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.aus.programs.dwm.autostart;
  blockingConfig = ''
    #!${pkgs.runtimeShell}
    ${lib.concatStringsSep "\n" cfg.blocking}
    disown'';
  nonBlockingConfig = ''
    #!${pkgs.runtimeShell}
    ${lib.concatStringsSep "\n" cfg.non-blocking}
    disown'';
in {
  options = {
    aus.programs.dwm.autostart = {
      enable = lib.mkEnableOption "Enable dwm autostart";
      blocking = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "A list of shell commands that will be executed when dwm starts.";
      };
      non-blocking = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "A list of shell commands that will be executed when dwm starts, but will not block dwm from starting.";
      };
    };
  };

  config =
    lib.mkIf config.aus.programs.dwm.autostart.enable
    {
      home.file.".dwm/autostart_blocking.sh" = {
        text = blockingConfig;
        executable = true;
      };
      home.file.".dwm/autostart.sh" = {
        text = nonBlockingConfig;
        executable = true;
      };
    };
}
