{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.aus.programs.shell.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        line_break.disabled = true;
        status = {
          disabled = false;
          symbol = "✖ ";
        };
        kubernetes.disabled = false;
        time.disabled = false;
      };
    };
  };
}
