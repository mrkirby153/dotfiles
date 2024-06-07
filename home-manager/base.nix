{
  pkgs,
  config,
  lib,
  ...
}: {
  options.aus = {
    username = lib.mkOption {
      type = lib.types.str;
      example = "austin";
      description = "The username of this host";
    };
    home = lib.mkOption {
      type = lib.types.str;
      example = "/home/austin";
      description = "The home directory of this host";
    };
    uid = lib.mkOption {
      type = lib.types.int;
      example = 1000;
      description = "The uid of this user";
    };
  };

  config = {
    # Set up home manager
    home.username = config.aus.username;
    home.homeDirectory = config.aus.home;

    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
    news.display = "silent";

    xsession.enable = true;
    home.packages = with pkgs; [
      httpie
      nix-prefetch-scripts
      nix-output-monitor
      nil
      comma
      pypulse
    ];

    systemd.user.startServices = "sd-switch";

    sops = {
      defaultSymlinkPath = "/run/user/${toString config.aus.uid}/secrets";
      defaultSecretsMountPoint = "/run/user/${toString config.aus.uid}/secrets.d";
    };
  };
}
