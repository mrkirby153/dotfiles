{
  config,
  pkgs-unstable,
  lib,
  aus,
  ...
}: let
  cfg = config.aus.programs.cloudflared;
  cloudflare_tunnel = aus.lib.shellScript {
    name = "cloudflare-tunnel";
    path = ./cloudflare_tunnel;
    deps = with pkgs-unstable; [
      cloudflared
    ];
  };
in {
  options = {
    aus.programs.cloudflared = {
      enable = lib.mkEnableOption "Enable cloudflared";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs-unstable; [
      cloudflared
      cloudflare_tunnel
    ];

    sops.secrets.cloudflared = {
      sopsFile = ../../secrets/cloudflared.json;
      format = "binary";
      path = "${config.aus.home}/.cloudflared/ae9763df-d0e2-4eeb-8234-4a2cff487310.json";
    };
  };
}
