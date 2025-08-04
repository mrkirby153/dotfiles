{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.aus.programs.shell.hyfetch;
  backend_packages = {
    neofetch = pkgs.neofetch;
    fastfetch = pkgs.fastfetch;
  };
  backend = backend_packages.${cfg.backend};

  configuration = {
    inherit (cfg) lightness backend;
    preset = "rainbow";
    mode = "rgb";
    light_dark = "dark";
    color_align = {
      mode = "horizontal";
      custom_colors = [];
      fore_back = null;
    };
    args = null;
    distro = null;
    pride_month_shown = [];
    pride_month_disable = false;
  };
in {
  options.aus.programs.shell = {
    hyfetch = {
      enable = lib.mkEnableOption "Enable hyfetch";
      backend = lib.mkOption {
        type = lib.types.enum ["neofetch" "fastfetch"];
        default = "fastfetch";
        description = "The backend to use for fetching system information.";
      };
      scheme = lib.mkOption {
        type = lib.types.enum ["light" "dark"];
        default = "dark";
        description = "The color scheme to use for hyfetch.";
      };
      lightness = lib.mkOption {
        type = lib.types.float;
        default = 0.65;
        description = "The lightness of the color scheme, between 0 and 1.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [backend pkgs.hyfetch];
    xdg.configFile."hyfetch.json".text = builtins.toJSON configuration;
  };
}
