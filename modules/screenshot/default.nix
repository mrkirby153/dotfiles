{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    aus.programs.screenshot.enable = lib.mkEnableOption "screenshot tool";
  };
  config = lib.mkIf config.aus.programs.screenshot.enable {
    sops.secrets.screenshot_key = {
      sopsFile = ../../secrets/screenshot_key.txt;
      format = "binary";
      path = "${config.aus.home}/.screenshot_key";
    };

    home.packages = [
      pkgs.screenshot
    ];
  };
}
