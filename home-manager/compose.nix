{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.aus.programs.compose;

  setComposeKey = pkgs.writeShellScriptBin "set-compose-key" ''
    #!${pkgs.runtimeShell}
    ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option compose:${cfg.key}
  '';
in {
  options = {
    aus.programs.compose = {
      enable = lib.mkEnableOption "Enable X11 compose key";
      key = lib.mkOption {
        type = lib.types.str;
        default = "ralt";
        description = "Key to use as compose key";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [setComposeKey];
    home.activation.composeKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ${setComposeKey}/bin/set-compose-key
    '';
    aus.programs.dwm.autostart.non-blocking = [
      "${setComposeKey}/bin/set-compose-key"
    ];
  };
}
