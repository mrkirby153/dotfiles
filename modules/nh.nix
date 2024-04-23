{ pkgs, lib, config, pkgs-unstable, ... }:
let
  cfg = config.aus.programs.nh;
  nh = pkgs-unstable.nh;
  wrappedNh = if (cfg.flake != null) then pkgs.writeScriptBin "nh" ''
    export FLAKE="${cfg.flake}"
    exec ${nh}/bin/nh "$@"
  '' else nh;
in
{
  options.aus.programs.nh = {
    enable = lib.mkEnableOption "Enable nh";
    flake = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
      The path used for the FLAKE environment variable
      '';
    };
  };

  config = {
    home = lib.mkIf cfg.enable {
      packages = [
        wrappedNh
      ];
    };
  };
}