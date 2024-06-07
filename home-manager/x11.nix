{
  pkgs,
  lib,
  config,
  ...
}: let
  theme = {
    nord0 = "#2E3440";
    nord1 = "#3B4252";
    nord2 = "#434C5E";
    nord3 = "#4C566A";
    nord4 = "#D8DEE9";
    nord5 = "#E5E9F0";
    nord6 = "#ECEFF4";
    nord7 = "#8FBCBB";
    nord8 = "#88C0D0";
    nord9 = "#81A1C1";
    nord10 = "#5E81AC";
    nord11 = "#BF616A";
    nord12 = "#D08770";
    nord13 = "#EBCB8B";
    nord14 = "#A3BE8C";
    nord15 = "#B48EAD";
  };
in {
  options.aus.programs.x11 = {
    enable = lib.mkEnableOption "Enable graphical environment";
  };

  config = lib.mkIf config.aus.programs.x11.enable {
    home.packages = with pkgs; [
      aus.st
      aus.dwm
      aus.dmenu
    ];
    xresources.properties = {
      "*.foreground" = theme.nord4;
      "*.background" = theme.nord0;
      "*.cursorColor" = theme.nord4;
      "*fading" = 35;
      "*fadeColor" = theme.nord3;
      "*.color0" = theme.nord1;
      "*.color1" = theme.nord11;
      "*.color2" = theme.nord14;
      "*.color3" = theme.nord13;
      "*.color4" = theme.nord9;
      "*.color5" = theme.nord15;
      "*.color6" = theme.nord8;
      "*.color7" = theme.nord5;
      "*.color8" = theme.nord3;
      "*.color9" = theme.nord11;
      "*.color10" = theme.nord14;
      "*.color11" = theme.nord13;
      "*.color12" = theme.nord9;
      "*.color13" = theme.nord15;
      "*.color14" = theme.nord7;
      "*.color15" = theme.nord6;
    };

    home.file."theme" = {
      text = builtins.toJSON {
        special = {
          background = theme.nord0;
          foreground = theme.nord4;
          cursor = theme.nord4;
        };
        colors = {
          color0 = theme.nord1;
          color1 = theme.nord11;
          color2 = theme.nord14;
          color3 = theme.nord13;
          color4 = theme.nord9;
          color5 = theme.nord15;
          color6 = theme.nord8;
          color7 = theme.nord5;
          color8 = theme.nord3;
          color9 = theme.nord11;
          color10 = theme.nord14;
          color11 = theme.nord13;
          color12 = theme.nord9;
          color13 = theme.nord15;
          color14 = theme.nord7;
          color15 = theme.nord6;
        };
      };
    };
  };
}
