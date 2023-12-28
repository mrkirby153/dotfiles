{
  pkgs,
  lib,
  config,
  ...
}: let
  screenshot = "${pkgs.scripts.screenshot}/bin/screenshot";
  pypulse = "${pkgs.pypulse}/bin/pypulse";

  update_dwmblocks = block: "${pkgs.procps}/bin/pkill -RTMIN+${builtins.toString block} dwmblocks";
in {
  options.aus = {
    programs.sxhkd.enable = lib.mkEnableOption "sxhkd";
  };

  config = lib.mkIf config.aus.programs.sxhkd.enable {
    services.sxhkd = {
      enable = true;
      keybindings = {
        "super + z" = "firefox";
        "super + shift + z" = "firefox --private-window";

        "super + n" = "thunar";
        "super + g" = "galculator";

        # Screenshots
        "super + s" = "${screenshot} -r";
        "super + shift + s ; {r, f, l}" = "${screenshot} {--record, --freeze -r, --floating}";
        "super + shift + s ; c" = "${pkgs.maim}/bin/maim -s | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";

        # Media Control
        "shift + XF86AudioPlay" = "pavucontrol";
        "alt + XF86AudioPlay" = "catia";
        "shift + { XF86AudioLowerVolume, XF86AudioRaiseVolume}" = "${pypulse} {--speakers, --headphones} ; ${update_dwmblocks 10}";
        "super + XF86AudioRaiseVolume" = "${pypulse} -l ; ${update_dwmblocks 10}";
        "{XF86AudioPlay, XF86AudioNext, XF86AudioPrev}" = "${pkgs.scripts.media_control}/bin/media_control {play-pause, next, previous}; ${update_dwmblocks 2}";
        "XF86AudioMute" = "${pkgs.pamixer}/bin/pamixer -t ; ${update_dwmblocks 10}";

        "super + Pause" = "${pkgs.scripts.power_menu}/bin/power_menu";

        "super + d" = "${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop --dmenu=\"${pkgs.aus.dmenu}/bin/dmenu -c -l 20 -i\" --display-binary";
        "super + r" = "${pkgs.aus.dmenu}/bin/dmenu_run -c -l 20 -i";

        "super + p" = "${pkgs.scripts.ocr}/bin/ocr";
        "alt + super + m" = "${pkgs.aus.st}/bin/st -c ncmpcpp -e ncmpcpp";
      };
    };
  };
}
