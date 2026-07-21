{
  config,
  pkgs,
  lib,
  aus,
  ...
}: let
  cfg = config.aus.programs.ffsend;

  ffsend = aus.lib.wrapProgram {
    pkg = pkgs.ffsend;
    binaryName = "ffsend";
    args = "--set FFSEND_HOST \"${cfg.host}\"";
  };
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
      ffsend
    ];
  };
}
