{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.aus.programs.shell.enable {
    programs.fzf = {
      enable = true;
    };
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    programs.thefuck = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
