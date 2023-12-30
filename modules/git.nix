{
  lib,
  config,
  ...
}: {
  options = {
    aus.programs.git = {
      enable = lib.mkEnableOption "Enable git";
      sign = {
        enable = lib.mkEnableOption "Enable git signing";
        key = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "The key to use for signing git commits";
        };
      };
    };
  };

  config = lib.mkIf config.aus.programs.git.enable {
    programs.git = {
      enable = true;
      userName = "mrkirby153";
      userEmail = "mr.austinwhyte@gmail.com";
      aliases = {
      };
      extraConfig = {
        commit.verbose = true;
        fetch.prune = true;
        push.autoSetupRemote = true;
        init.defaultBranch = "main";
        core.autocrlf = "input";
        url = {
          "git@github.com:" = {
            insteadOf = "https://github.com/";
          };
        };
      };
      delta = {
        enable = true;
        options = {
          navigate = true;
          light = false;
          line-numbers = true;
        };
      };
      signing = lib.mkIf config.aus.programs.git.sign.enable {
        key = config.aus.programs.git.sign.key;
        signByDefault = true;
      };
    };
  };
}
