{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: let
  cfg = config.aus.programs.git;
  globalIgnore = pkgs.writeText "globalignore" cfg.globalignore or "";
in {
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
      username = lib.mkOption {
        type = lib.types.str;
        default = "mrkirby153";
        description = "The username to use for git commits";
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "mr.austinwhyte@gmail.com";
        description = "The email to use for git commits";
      };
      globalignore = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "A list of global gitignore patterns";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    aus.programs.git.globalignore = builtins.readFile ./globalignore;
    programs.git = {
      enable = true;
      settings = {
        user.name = cfg.username;
        user.email = cfg.email;
        commit.verbose = true;
        fetch.prune = true;
        push.autoSetupRemote = true;
        init.defaultBranch = "main";
        core.autocrlf = "input";
        core.excludesFile = "${globalIgnore}";
      };
      signing = lib.mkIf cfg.sign.enable {
        key = cfg.sign.key;
        signByDefault = true;
        signer = "gpg";
      };
    };
    programs.lazygit = {
      enable = true;
      package = pkgs-unstable.lazygit;
      settings = {
        gui.nerdFontsVersion = "3";
        quitOnTopLevelReturn = true;
        promptToReturnFromSubprocess = false;
        git.pagers = [
          {
            colorArg = "always";
            pager = "${pkgs.delta}/bin/delta --dark --paging=never";
          }
        ];
      };
    };
    programs.delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        line-numbers = true;
      };
      enableGitIntegration = true;
    };
  };
}
