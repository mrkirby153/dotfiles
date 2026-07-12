{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.aus.programs.claude.statusline;

  captures =
    lib.imap0 (i: s: ''sl${toString i}=$(${toString s} <<<"$INPUT")'')
    cfg.scripts;

  fmt = lib.concatMapStringsSep cfg.separator (_: "%s") cfg.scripts;

  args =
    lib.concatStringsSep " "
    (lib.imap0 (i: _: ''"$sl${toString i}"'') cfg.scripts);

  statusline = pkgs.writeShellScriptBin "${cfg.scriptName}" ''
    INPUT=$(cat)
    ${lib.optionalString cfg.debug.enable ''printf '%s\n' "$INPUT" > ${cfg.debug.path}''}
    ${lib.concatStringsSep "\n" captures}
    printf '${fmt}\n' ${args}
  '';
in {
  options.aus.programs.claude.statusline = {
    enable = lib.mkEnableOption "claude statusline";
    debug = {
      enable = lib.mkEnableOption "Enable debug logging for the statusline";
      path = lib.mkOption {
        type = lib.types.path;
        default = "/tmp/claude-statusline-input.json";
        description = "Path to write the statusline input JSON to for debugging";
      };
    };
    scripts = lib.mkOption {
      type = lib.types.listOf (lib.types.either lib.types.path lib.types.str);
      description = ''
        Scripts whose outputs are concatenated into the statusline. Each is
        fed the statusline JSON on stdin. A Nix store path is copied into the
        store; a string is emitted verbatim (so shell vars expand at runtime).
      '';
      example = [''node "$PLUGIN/scripts/statusline.mjs"''];
      default = [];
    };
    separator = lib.mkOption {
      type = lib.types.str;
      description = "Separator placed between each script's output.";
      example = " | ";
      default = "  ";
    };
    scriptName = lib.mkOption {
      type = lib.types.str;
      description = "The name of the statusline script";
      example = "claude-statusline";
      default = "claude-statusline";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [statusline];
  };
}
