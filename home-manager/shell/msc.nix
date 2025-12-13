{
  config,
  lib,
  pkgs-unstable,
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
      nix-direnv.package = pkgs-unstable.nix-direnv;
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
