{pkgs, ...}: {
  config.aus.dwmblocks = {
    blocks = {
      music = {
        cmd = {
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
        order = 1;
      };
      memory = {
        cmd = {
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
        order = 2;
      };
      cpu = {
        cmd = {
          path = ./blocks/cpu;
          deps = with pkgs; [
            gamemode
            unixtools.top
            gnugrep
            gawk
            gnused
            lm_sensors
            util-linux
            btop
          ];

          pure = false;
        };
        interval = 3;
        signal = 4;
        order = 3;
      };
      gpu = {
        cmd.path = ./blocks/gpu;
        cmd.pure = false;
        interval = 3;
        signal = 8;
        order = 4;
      };
      clock = {
        cmd = {
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
        order = 5;
      };
      mail = {
        cmd = {
          path = ./blocks/mail;
          deps = with pkgs; [
            util-linux
            findutils
            coreutils
          ];
        };
        interval = 10;
        signal = 6;
        order = 6;
      };
      volume = {
        cmd = {
          path = ./blocks/volume;
          deps = with pkgs; [
            pypulse
            aus.dmenu
            jq
            pamixer
            gawk
            coreutils
          ];
        };
        interval = 60;
        signal = 10;
        order = 7;
      };
      updates = {
        cmd = {
          path = ./blocks/updates;
          pure = false;
          deps = with pkgs; [
            libnotify
            coreutils
          ];
        };
        interval = 10;
        signal = 9;
        order = 8;
      };
      mouse_battery = {
        cmd = {
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
        order = 9;
      };
      indicator_keys = {
        cmd = {
          path = ./blocks/indicator_keys;
          deps = with pkgs; [
            xorg.xset
            gnused
          ];
        };
        interval = 3;
        signal = 11;
        order = 10;
      };
      internet = {
        cmd = {
          path = ./blocks/internet;
          deps = with pkgs; [
            gawk
          ];
        };
        interval = 30;
        signal = 7;
        order = 11;
      };
    };
  };
}
