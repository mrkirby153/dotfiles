{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    aus.programs.attic = {
      enable = lib.mkEnableOption "Enable attic";
    };
  };
  config = lib.mkIf config.aus.programs.attic.enable {
    home.packages = with pkgs; [
      # attic-client
    ];

    sops.secrets.attic = {
      sopsFile = ../secrets/attic.toml;
      format = "binary";
      path = "${config.aus.home}/.config/attic/config.toml";
    };
  };
}
