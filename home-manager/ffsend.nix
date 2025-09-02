{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.aus.programs.ffsend;

  wrappedFfsend = pkgs.writeScriptBin "ffsend" ''
    export FFSEND_HOST="${cfg.host}"
    exec ${lib.getExe pkgs.ffsend} "$@"
  '';
in {
  options.aus = {
    programs.ffsend = {
      enable = lib.mkEnableOption "ffsend";
      host = lib.mkOption {
        type = lib.types.str;
        default = "https://send.mrkirby153.com";
        description = "The send host to use";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      wrappedFfsend
    ];
  };
}
