{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.aus.programs.rofi;
in {
  options = {
    aus.programs.rofi = {
      enable = lib.mkEnableOption "Enable rofi application launcher";
      dmenu = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable rofi as dmenu replacement";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      [
        rofi
      ]
      ++ lib.optional cfg.dmenu dmenu-rofi;

    xdg.configFile = {
      "rofi/config.rasi".text = builtins.readFile ./config.rasi;
      "rofi/nord.rasi".text = builtins.readFile ./nord.rasi;
      "dmenu_path" = {
        text = "${pkgs.dmenu-rofi}/bin/dmenu";
        enable = cfg.dmenu;
      };
    };
  };
}
