{
  lib,
  config,
  ...
}:
let
  cfg = config.aus.programs.claude;
in
{
  options = {
    aus.programs.claude = {
      enable = lib.mkEnableOption "Enable claude";
    };
  };

  config = lib.mkIf cfg.enable {
    aus.programs.git.globalignore = ''
      .claude/settings.local.json
      .mcp.json
    '';
    aus.programs.claude.statusline = {
      enable = true;
      scripts = [
        ./statusline
      ];
    };
  };
}
