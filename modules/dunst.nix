{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    aus.programs.dunst = {
      enable = lib.mkEnableOption "dunst";
    };
  };

  config = lib.mkIf config.aus.programs.dunst.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          monitor = 0;
          follow = "none";
          width = 300;
          height = 300;
          origin = "top-right";
          offset = "10x50";
          scale = 0;
          notification_limit = 0;
          progress_bar = true;
          progress_bar_height = 10;
          progress_bar_frame_width = 1;
          progress_bar_min_width = 150;
          progress_bar_max_width = 300;

          indicate_hidden = "yes";
          transparency = 0;
          separator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          text_icon_padding = 0;
          frame_width = 3;
          frame_color = "#aaaaaa";
          separator_color = "frame";
          sort = "no";

          font = "Monospace 8";
          line_height = 0;
          markup = "full";
          format = "<b>%s</b>\n%b";
          alignment = "left";
          vertical_alignment = "center";
          show_age_threshold = 60;
          ellipsize = "middle";
          ignore_newline = "no";
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = "yes";

          icon_positon = "left";
          min_icon_size = 0;
          max_icon_size = 64;
          icon_path = "/usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/";

          sticky_history = "yes";
          history_length = 20;

          dmenu = "${pkgs.aus.dmenu}/bin/dmenu -p dunst:";
          browser = "${pkgs.xdg-utils}/bin/xdg-open";

          always_run_script = true;
          title = "Dunst";
          class = "Dunst";
          corner_radius = 5;

          ignore_dbusclose = false;
          force_xwayland = false;
          force_xinerama = false;
          mouse_left_click = "close_current";
          mouse_middle_click = "do_action, close_current";
          mouse_right_click = "close_all";
        };
        experimental = {
          per_monitor_dpi = false;
        };
        urgency_low = {
          background = "#222222";
          foreground = "#888888";
          timeout = 10;
        };
        urgency_normal = {
          background = "#285577";
          foreground = "#ffffff";
          timeout = 10;
        };
        urgency_critical = {
          background = "#900000";
          foreground = "#ffffff";
          frame_color = "#ff0000";
          timeout = 0;
        };
      };
    };
  };
}
