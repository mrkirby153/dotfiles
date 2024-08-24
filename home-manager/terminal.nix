{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.aus.terminal;

  fallbackSnippet = ''
    if ! command -v ${cfg.terminal} &> /dev/null; then
      exec ${cfg.fallback} "$@"
      exit
    fi
  '';
  wrapperProgram = pkgs.writeScriptBin "default-terminal" ''
    #!${pkgs.runtimeShell}
    ${pkgs.lib.strings.optionalString (cfg.fallback != null) fallbackSnippet}
    exec ${cfg.terminal} "$@"
  '';
in {
  options = {
    aus.terminal = {
      enable = lib.mkEnableOption "terminal";
      terminal = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "The default terminal emulator to use.";
      };
      fallback = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "${pkgs.aus.st}/bin/st";
        description = "The fallback terminal emulator to use.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.terminal != null;
        message = "You must specify a default terminal to use";
      }
    ];
    home.packages = [wrapperProgram];
  };
}
