{
  pkgs,
  lib,
  config,
  ...
}: let
  shellScript = import ../../lib/shellScript.nix {
    inherit pkgs;
    lib = pkgs.lib;
    runtimeShell = pkgs.runtimeShell;
    writeTextFile = pkgs.writeTextFile;
  };

  getBlock = {
    name,
    path,
    pure ? true,
    deps ? [],
  }: let
    real_path =
      if builtins.hasAttr name config.aus.programs.dwmblocks.block_overrides
      then config.aus.programs.dwmblocks.block_overrides.${name}
      else path;
  in "${shellScript {
    inherit name;
    path = real_path;
    inherit pure;
    inherit deps;
  }}/bin/${name}";

  dwmblocks = pkgs.dwmblocks {
    blocks = [
      {
        command = getBlock {
          name = "music";
          path = ./blocks/music;
          deps = with pkgs; [
            scripts.media_control
            playerctl
            mpc-cli
            gnused
            gnugrep
          ];
        };
        interval = 1;
        signal = 2;
      }
      {
        command = getBlock {
          name = "memory";
          path = ./blocks/memory;
          deps = with pkgs; [
            polkit
            scripts.drop_zfs_cache
            util-linux
            gnugrep
            gawk
            bc
          ];
        };
        interval = 1;
        signal = 3;
      }
      {
        command = getBlock {
          name = "cpu";
          path = ./blocks/cpu;
          deps = with pkgs; [
            gamemode
            unixtools.top
            gnugrep
            gawk
            gnused
            lm_sensors
          ];
        };
        interval = 3;
        signal = 4;
      }
      {
        command = getBlock {
          name = "gpu";
          path = ./blocks/gpu;
          pure = false;
        };
        interval = 3;
        signal = 8;
      }
      {
        command = getBlock {
          name = "clock";
          path = ./blocks/clock;
          deps = with pkgs; [
            libnotify
            util-linux
            coreutils
            findutils
          ];
        };
        interval = 10;
        signal = 5;
      }
      {
        command = getBlock {
          name = "mail";
          path = ./blocks/mail;
          deps = with pkgs; [
            util-linux
            findutils
            coreutils
          ];
        };
        interval = 10;
        signal = 5;
      }
      {
        command = getBlock {
          name = "volume";
          path = ./blocks/volume;
          deps = with pkgs; [
            pypulse
            jq
            pamixer
            gawk
            coreutils
          ];
        };
        interval = 10;
        signal = 6;
      }
      {
        command = getBlock {
          name = "updates";
          path = ./blocks/updates;
          pure = false;
          deps = with pkgs; [
            libnotify
            coreutils
          ];
        };
        interval = 10;
        signal = 9;
      }
      {
        command = getBlock {
          name = "mouse_battery";
          path = ./blocks/mouse_battery;
          deps = with pkgs; [
            upower
            findutils
            gnugrep
            gawk
            coreutils
          ];
        };
        interval = 30;
        signal = 8;
      }
      {
        command = getBlock {
          name = "indicator_keys";
          path = ./blocks/indicator_keys;
          deps = with pkgs; [
            xorg.xset
            gnused 
          ];
        };
        interval = 3;
        signal = 11;
      }
      {
        command = getBlock {
          name = "internet";
          path = ./blocks/internet;
          deps = with pkgs; [
            gawk
          ];
        };
        interval = 30;
        signal = 7;
      }
    ];
    delimiter = " | ";
  };
in {
  options.aus.programs.dwmblocks = {
    enable = lib.mkEnableOption "dwmblocks";
    block_overrides = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = {};
      description = "Override the default blocks";
    };
  };

  config = lib.mkIf config.aus.programs.dwmblocks.enable {
    programs.dwmblocks = {
      enable = true;
      pkg = dwmblocks;
    };
  };
}
