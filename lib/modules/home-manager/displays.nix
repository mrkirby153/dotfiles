{
  pkgs,
  lib,
  config,
  aus,
  ...
}: let
  posType = lib.types.submodule {
    options = {
      x = lib.mkOption {
        description = "X position of the display";
        type = lib.types.int;
      };
      y = lib.mkOption {
        description = "Y position of the display";
        type = lib.types.int;
      };
    };
  };
  resolutionType = lib.types.submodule {
    options = {
      width = lib.mkOption {
        description = "The width of the display";
        type = lib.types.int;
      };
      height = lib.mkOption {
        description = "The height of the display";
        type = lib.types.int;
      };
    };
  };
  displayType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        description = "Name of the display";
        type = lib.types.str;
      };
      enable = lib.mkEnableOption "Enable display";
      primary = lib.mkEnableOption "Make display primary";
      pos = lib.mkOption {
        type = posType;
        description = "The position of the display";
        default = {
          x = 0;
          y = 0;
        };
      };
      rate = lib.mkOption {
        type = lib.types.float;
        description = "The refresh rate of the display";
        default = 60.0;
      };
      rotate = lib.mkOption {
        type = lib.types.enum ["normal" "left" "right" "inverted"];
        description = "How the display should be rotated";
        default = "normal";
      };
      mode = lib.mkOption {
        type = resolutionType;
        description = "The resolution of the display";
        default = {
          width = 1920;
          height = 1080;
        };
      };
    };
  };

  configType = lib.types.submodule {
    options = {
      displays = lib.mkOption {
        type = lib.types.listOf displayType;
        description = "The displays to configure";
      };
      keybind = lib.mkOption {
        type = lib.types.str;
        description = "The keybind to use to toggle the display";
        default = "";
      };
      default = lib.mkOption {
        type = lib.types.bool;
        description = "Whether this is the default profile";
        default = false;
      };
    };
  };

  toXrandr = aus.lib.randr;
  profileNames = builtins.attrNames config.aus.displays;

  asCase = name: command: ''
    "${name}")
      ${command}
      ;;'';

  xrandrCommands = builtins.mapAttrs (name: display: toXrandr display.displays) config.aus.displays;

  shellScript = pkgs.writeShellScriptBin "displays" ''
    [ $# -ne 1 ] && echo "Usage: displays <${builtins.concatStringsSep "|" profileNames}>" && exit 1
    case "$1" in
      ${builtins.concatStringsSep "\n" (builtins.attrValues (builtins.mapAttrs asCase xrandrCommands))}
      *)
        echo "Unknown profile $1"
        exit 1
        ;;
    esac
  '';

  keybinds = let
    candidates = lib.attrsets.filterAttrs (key: config: config.keybind != "") config.aus.displays;
    keybindAttrs =
      builtins.mapAttrs (profile: config: {
        name = config.keybind;
        value = "${shellScript}/bin/displays ${profile}";
      })
      candidates;
  in
    builtins.listToAttrs (builtins.attrValues keybindAttrs);

  defaultProfiles = builtins.attrNames (lib.attrsets.filterAttrs (key: config: config.default) config.aus.displays);
in
  with lib; {
    options.aus = {
      displays = lib.mkOption {
        default = {};
        type = with types;
          attrsOf configType;
        description = "The displays to configure";
      };
    };

    config = lib.mkIf (config.aus.displays != {}) {
      assertions = [
        {
          assertion = length defaultProfiles <= 1;
          message = "Only one display profile can be the default";
        }
      ];
      home.packages = [
        shellScript
      ];
      services.sxhkd.keybindings = keybinds;

      aus.programs.dwm.autostart.non-blocking = lib.mkIf (length defaultProfiles > 0) ["${shellScript}/bin/displays \"${builtins.head defaultProfiles}\""];
    };
  }
