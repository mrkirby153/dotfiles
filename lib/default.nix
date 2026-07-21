{pkgs}: let
  lib = pkgs.lib;
in {
  displays = import ./displays.nix {inherit lib;};
  randr = import ./randr.nix {
    xrandr = pkgs.xrandr;
  };
  shellScript = import ./shellScript.nix {
    inherit pkgs;
    inherit lib;
    inherit (pkgs) runtimeShell;
    inherit (pkgs) writeTextFile;
  };
  wrapProgram = import ./wrapProgram.nix {
    inherit pkgs;
  };
}
