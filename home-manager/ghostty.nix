{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.aus.programs.ghostty;
  ghostty-mock = pkgs.writeShellScriptBin "__ghostty_mock" ''
    true
  '';
in {
  options.aus.programs.ghostty = {
    enable = lib.mkEnableOption "ghostty";
  };

  config = {
    programs.ghostty = lib.mkIf cfg.enable {
      enable = true;
      package = ghostty-mock;
      enableZshIntegration = true;
      settings = {
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
