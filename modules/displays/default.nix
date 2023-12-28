{
  pkgs,
  lib,
  config,
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
  toXrandr = import ./randr.nix {pkgs = pkgs;};
  profileNames = builtins.attrNames config.aus.displays;

  asCase = name: command: ''
    "${name}")
      ${command}
      ;;'';

  xrandrCommands = builtins.mapAttrs (name: display: toXrandr display) config.aus.displays;

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
in
  with lib; {
    options.aus = {
      displays = lib.mkOption {
        default = {};
        type = with types;
          attrsOf (
            listOf displayType
          );
        description = "The displays to configure";
      };
    };

    config = lib.mkIf (config.aus.displays != {}) {
      home.packages = [
        shellScript
      ];
    };
  }
