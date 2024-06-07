{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.aus.omzExtraPlugins;
  asCopyCommand = name: path: "cp -r ${path} $out/plugins/${name}";
  copyCommands = builtins.attrValues (builtins.mapAttrs asCopyCommand cfg);
  omz-custom = pkgs.stdenv.mkDerivation {
    name = "omz-custom";
    phases = ["buildPhase"];
    buildPhase = ''
      mkdir -pv $out/plugins
      ${builtins.concatStringsSep "\n" copyCommands}
    '';
  };
in {
  options = {
    aus.omzExtraPlugins = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = {};
      description = "List of additional oh-my-zsh plugins to enable";
    };
    aus.extraPaths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of additional paths to add to PATH";
    };
  };

  config = {
    programs.zsh.oh-my-zsh = lib.mkIf (config != {}) {
      plugins = builtins.attrNames cfg;
      custom = "${omz-custom}";
    };
    programs.zsh.initExtra =
      if config.aus.extraPaths != []
      then ''
        export PATH="${builtins.concatStringsSep ":" config.aus.extraPaths}:$PATH"
      ''
      else "";
  };
}
