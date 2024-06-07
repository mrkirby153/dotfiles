{
  pkgs,
  lib,
  aus,
  config,
  ...
}: let
  shellScript = aus.lib.shellScript;

  command = lib.types.submodule {
    options = {
      path = lib.mkOption {
        type = lib.types.path;
        description = "Path to the block script";
      };
      deps = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = "List of packages to install for the block";
      };
      pure = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether the block is pure and doesn't depend on any host packages";
      };
    };
  };

  block = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable the block";
      };

      cmd = lib.mkOption {
        type = command;
        description = "The command to run for this block";
      };

      interval = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "The interval in seconds to update the block";
      };
      signal = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "The signal used to force an update of the block";
      };
      order = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "The order in which to display the block";
      };
    };
  };

  makeBlockScript = {
    name,
    path,
    pure,
    deps,
  }:
    lib.getExe (shellScript {
      inherit name;
      inherit path;
      inherit pure;
      inherit deps;
    });

  enabledBlocks = lib.attrsets.filterAttrs (name: value: value.enable) config.aus.dwmblocks.blocks;

  blocks =
    lib.attrsets.mapAttrsToList (name: value: {
      command = makeBlockScript {
        inherit name;
        path = value.cmd.path;
        pure = value.cmd.pure;
        deps = value.cmd.deps;
      };
      interval = value.interval;
      signal = value.signal;
      order = value.order;
    })
    enabledBlocks;

  sortedBlocks = map (x: removeAttrs x ["order"]) (builtins.sort (a: b: a.order < b.order) blocks);

  blockPackage = pkgs.dwmblocks {
    blocks = sortedBlocks;
    delimiter = " | ";
  };

  restartStatusbar = pkgs.writeShellScriptBin "statusbar_restart" ''
    killall -q dwmblocks
    ${pkgs.util-linux}/bin/setsid -f ${lib.getExe blockPackage}
  '';
in {
  options.aus = {
    dwmblocks = {
      enable = lib.mkEnableOption "dwmblocks";
      blocks = lib.mkOption {
        type = lib.types.attrsOf block;
        default = {};
        description = "List of blocks to enable";
      };
      delimiter = lib.mkOption {
        type = lib.types.string;
        default = " | ";
        description = "The delimiter to use between blocks";
      };
    };
  };

  config = lib.mkIf config.aus.dwmblocks.enable {
    home.packages = [restartStatusbar];
    aus.programs.dwm.autostart.non-blocking = [(lib.getExe restartStatusbar)];
  };
}
