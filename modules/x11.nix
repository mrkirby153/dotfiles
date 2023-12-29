{
  pkgs,
  lib,
  config,
  ...
}: {
  options.aus.programs.x11 = {
    enable = lib.mkEnableOption "Enable graphical environment";
  };

  config = lib.mkIf config.aus.programs.x11.enable {
    home.packages = with pkgs; [
      aus.st
      aus.dwm
      aus.dmenu
    ];
  };
}
