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

  initContent = lib.mkOrder 1000 (
    lib.strings.optionalString (config.aus.extraPaths != []) "export PATH=\"${builtins.concatStringsSep ":" config.aus.extraPaths}:$PATH]\""
  );

  keybindContent = let
    mapped = lib.mapAttrsToList (name: value: "bindkey '${name}' ${value}") config.programs.zsh.keybinds;
  in
    lib.mkOrder 1500 (lib.concatStringsSep "\n" mapped);
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
    programs.zsh.keybinds = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Zsh keybindings to set up";
    };
  };

  config = {
    programs.zsh.oh-my-zsh = lib.mkIf (config != {}) {
      plugins = builtins.attrNames cfg;
      custom = "${omz-custom}";
    };
    programs.zsh.initContent = lib.mkMerge [initContent keybindContent];
  };
}
