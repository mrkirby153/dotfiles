{pkgs, ...}: let
  allDisplays = ["DP-0" "DP-1" "DP-2" "DP-3" "DP-4" "DP-5" "HDMI-0"];
  displaysFunc = import ../../lib/displays.nix {lib = pkgs.lib;};
  displays = displaysFunc.asDisplays allDisplays;
in {
  config.aus = {
    username = "austin";
    home = "/home/austin";
    uid = 1000;

    wallpaper = {
      enable = true;
      path = ./xenoblade.png;
    };

    dwmblocks.enable = true;

    terminal = {
      enable = true;
      terminal = "ghostty";
      fallback = null;
    };

    programs = {
      screenshot.enable = true;
      scripts.enable = true;
      sxhkd.enable = true;
      dwm = {
        autostart.enable = true;
      };
      autostart.enable = true;
      x11.enable = true;
      shell = {
        enable = true;
        hyfetch.enable = true;
      };
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
      vim.enable = true;
      mail.enable = true;
      nh = {
        enable = true;
        flake = "/home/austin/Development/nix/dotfiles";
      };
      ghostty.enable = true;
    };

    displays.displays = {
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

    sops.enable = true;
  };
}
