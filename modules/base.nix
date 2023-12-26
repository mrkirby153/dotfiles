{
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
  };

  config = {
    # Set up home manager
    home.username = config.aus.username;
    home.homeDirectory = config.aus.home;

    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
    news.display = "silent";
  };
}
