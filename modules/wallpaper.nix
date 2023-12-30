{
  pkgs, lib, config, ...
}:
{
  options = {
    aus.wallpaper  = {
      enable = lib.mkEnableOption "Enable wallpaper";
      path = lib.mkOption {
        type = lib.types.path;
        description = "The wallpaper";
      };
    };
  };

  config = lib.mkIf config.aus.wallpaper.enable {
    aus.programs.dwm.autostart = {
      non-blocking = ["${pkgs.feh}/bin/feh --bg-fill ${config.aus.wallpaper.path}"];
    };
    home.file."wallpaper" = {
      source = config.aus.wallpaper.path;
      target = "Pictures/wallpaper";
      onChange = ''
      ${pkgs.feh}/bin/feh --bg-fill ${config.aus.wallpaper.path}
      ${pkgs.betterlockscreen}/bin/betterlockscreen -u ${config.aus.wallpaper.path}
      '';
    };
  };
}