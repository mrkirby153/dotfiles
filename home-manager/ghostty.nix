{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.aus.programs.ghostty;
in {
  options.aus.programs.ghostty = {
    enable = lib.mkEnableOption "ghostty";
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      config = {
        theme = "nord";
        font-family = "SauceCodePro Nerd Font";
        font-size = 11;
        window-decoration = false;
        background-opacity = 0.9;
        minimum-contrast = 1.1;
        shell-integration-features = "no-cursor,no-sudo,title";
        cursor-style-blink = false;
        confirm-close-surface = false;
        copy-on-select = "clipboard";
        app-notifications = "no-clipboard-copy";
      };
    };
  };
}
