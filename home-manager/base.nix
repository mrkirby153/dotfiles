{
  pkgs,
  pkgs-unstable,
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
    home.homeDirectory = lib.mkForce config.aus.home;

    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
    news.display = "silent";

    xsession.enable = pkgs.stdenv.isLinux;
    home.packages = with pkgs;
      [
        httpie
        nix-prefetch-scripts
        nix-output-monitor
        nixd
        comma
        alejandra
        pkgs-unstable.binsider
      ]
      ++ (
        if stdenv.isLinux
        then [
          pypulse
        ]
        else []
      );

    systemd.user.startServices = "sd-switch";

    sops = lib.mkIf pkgs.stdenv.isLinux {
      defaultSymlinkPath = "/run/user/${toString config.aus.uid}/secrets";
      defaultSecretsMountPoint = "/run/user/${toString config.aus.uid}/secrets.d";
    };
  };
}
