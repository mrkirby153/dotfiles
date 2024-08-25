{
  lib,
  config,
  ...
}: let
  cfg = config.programs.ghostty;

  coerceValue = value:
    if builtins.isBool value
    then
      if value
      then "true"
      else "false"
    else toString value;

  configLine = key: value: ''
    ${key} = "${coerceValue value}"
  '';

  configFileText = ''
    # Managed by home-manager. Do not edit!
    ${builtins.concatStringsSep "\n" (builtins.attrValues (builtins.mapAttrs configLine cfg.config))}
  '';
in {
  options = {
    programs.ghostty = with lib; {
      enable = mkEnableOption "ghostty";
      config = mkOption {
        type = types.attrs;
        description = "Configuration file";
        default = {};
      };
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."ghostty/config" = {
      text = configFileText;
    };
  };
}
