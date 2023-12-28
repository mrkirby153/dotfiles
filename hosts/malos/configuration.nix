{...}: let
  makeDisabled = monitor: {name = monitor;};

  disabled_single = map makeDisabled ["DP-0" "DP-1" "DP-2" "DP-4" "DP-5" "HDMI-0"];
  disabled_dual = map makeDisabled ["DP-1" "DP-2" "DP-4" "DP-5" "HDMI-0"];
in {
  config.aus = {
    username = "austin";
    home = "/home/austin";

    programs = {
      screenshot.enable = true;
      scripts.enable = true;
      sxhkd.enable = true;
      dwm = {
        autostart.enable = true;
      };
    };

    displays = {
      single = disabled_single ++ [
        {
          name = "DP-3";
          enable = true;
          primary = true;
        }
      ];
      dual = disabled_dual ++ [
        {
          name = "DP-0";
          enable = true;
          primary = true;
        }
        {
          name = "DP-3";
          enable = true;
          pos = { x = 1920; y = 0;};
        }
      ];
    };
  };
}
