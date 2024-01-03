{xrandr}: let
  xrandr-bin = "${xrandr}/bin/xrandr";

  buildXrandrCommand = {
    name,
    enable ? false,
    primary ? false,
    pos ? {
      x = 0;
      y = 0;
    },
    rotate ? "normal",
    mode ? {
      width = 1920;
      height = 1080;
    },
  }:
    if enable
    then let
      displayPos = "${toString pos.x}x${toString pos.y}";
      resolution = "${toString mode.width}x${toString mode.height}";
      primaryFlag =
        if primary
        then "--primary"
        else "";
    in "--output ${name} --mode ${resolution} --pos ${displayPos} ${primaryFlag} --rotate ${rotate}"
    else "--output ${name} --off";
in
  monitors:
    xrandr-bin + " " + builtins.concatStringsSep " " (map buildXrandrCommand monitors)
