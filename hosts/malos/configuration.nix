{pkgs, ...}: let
  allDisplays = ["DP-0" "DP-1" "DP-2" "DP-3" "DP-4" "DP-5" "HDMI-0"];
  displaysFunc = import ../../lib/displays.nix {lib = pkgs.lib;};
  displays = displaysFunc.asDisplays allDisplays;
in {
  config.aus = {
    username = "austin";
    home = "/home/austin";

    wallpaper = {
      enable = true;
      path = ./xenoblade.png;
    };

    programs = {
      screenshot.enable = true;
      scripts.enable = true;
      sxhkd.enable = true;
      dwm = {
        autostart.enable = true;
      };
      autostart.enable = true;
      dwmblocks.enable = true;
      x11.enable = true;
      shell.enable = true;
      git = {
        enable = true;
        sign = {
          enable = true;
          key = "90EF2AB021AB6FED";
        };
      };
      attic.enable = true;
      dunst.enable = true;
      picom.enable = true;
    };

    displays = {
      single = {
        keybind = "super + shift + o";
        displays = displays [
          {
            name = "DP-3";
            enable = true;
            primary = true;
          }
        ];
      };
      dual = {
        keybind = "super + o";
        default = true;
        displays = displays [
          {
            name = "DP-0";
            enable = true;
            primary = true;
          }
          {
            name = "DP-3";
            enable = true;
            pos = {
              x = 1920;
              y = 0;
            };
          }
        ];
      };
    };
  };
}
