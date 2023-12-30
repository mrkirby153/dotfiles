{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    aus.programs.picom = {
      enable = lib.mkEnableOption "picom";
    };
  };
  config = lib.mkIf config.aus.programs.picom.enable {
    services.picom = {
      enable = true;

      settings = {
        glx-no-stencil = true;
        glx-copy-from-front = false;
        shadow-radius = 5;
        shadow-ignore-shaped = false;
        frame-opacity = 1;
        inactive-opacity-override = false;

        blur-background-fixed = false;
        blur-backround-exclude = [
          "window_type = 'dock'"
          "window_type = 'desktop'"
        ];
        mark-wmwin-focused = true;
        mark-ovredir-focused = true;
        use-ewmh-active-win = true;
        detect-rounded-corners = true;
        detect-client-opacity = true;
        vsync = true;
        dbe = false;

        unredir-if-possible = false;
        focus-exclude = [];
        detect-transient = true;
        detect-client-loader = true;

        wintypes = {
          toolip = {
            fade = true;
            shadow = false;
            opacity = 0.05;
            focus = true;
          };
        };
        xrender-sync-fence = true;
      };
      shadow = true;
      shadowOffsets = [
        (-5)
        (-5)
      ];
      shadowOpacity = 0.5;
      shadowExclude = [
        "! name~=''"
        "name = 'Notification'"
        "name = 'Plank'"
        "name = 'Docky'"
        "name = 'Kupfer'"
        "name = 'xfce4-notifyd'"
        "name = 'cpt_frame_window'"
        "name *= 'VLC'"
        "name *= 'compton'"
        "name *= 'picom'"
        "name *= 'Chromium'"
        "name *= 'Chrome'"
        "class_g = 'Firefox' && argb"
        "class_g = 'Conky'"
        "class_g = 'Kupfer'"
        "class_g = 'Synapse'"
        "class_g ?= 'Notify-osd'"
        "class_g ?= 'Cairo-dock'"
        "class_g ?= 'Xfce4-notifyd'"
        "class_g ?= 'Xfce4-power-manager'"
        "_GTK_FRAME_EXTENTS@:c"
        "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
      ];
      inactiveOpacity = 1;
      activeOpacity = 1;
      opacityRules = [
        "95:class_g = 'urxvt'"
        "95:class_g = 'URxvt'"
        "90:class_g *?= 'Rofi'"
      ];
      fade = true;
      fadeDelta = 4;
      fadeSteps = [0.03 0.03];
      fadeExclude = [];
    };
  };
}
