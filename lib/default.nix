{pkgs}: let
  lib = pkgs.lib;
in {
  displays = import ./displays.nix {inherit lib;};
  randr = import ./randr.nix {
    xrandr = pkgs.xorg.xrandr;
  };
  shellScript = import ./shellScript.nix {
    inherit pkgs;
    inherit lib;
    inherit (pkgs) runtimeShell;
    inherit (pkgs) writeTextFile;
  };
}
