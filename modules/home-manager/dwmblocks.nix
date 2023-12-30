{
  pkgs,
  lib,
  config,
  ...
}: let
  restartStatusbar = pkgs.writeShellScriptBin "statusbar_restart" ''
    killall -q dwmblocks
    ${pkgs.util-linux}/bin/setsid -f ${config.programs.dwmblocks.pkg}/bin/dwmblocks
  '';
in {
  options = {
    programs.dwmblocks = {
      enable = lib.mkEnableOption "Enable dwmblocks";
      pkg = lib.mkOption {
        type = lib.types.package;
        description = "The dwmblocks package";
        default = pkgs.dwmblocks;
      };
    };
  };

  config = lib.mkIf config.programs.dwmblocks.enable {
    home.packages = [restartStatusbar];
    aus.programs.dwm.autostart.non-blocking = ["${restartStatusbar}/bin/statusbar_restart"];
  };
}
