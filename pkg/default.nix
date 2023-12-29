{pkgs}: let
  scripts = pkgs.callPackage ./scripts {};
in {
  scripts = scripts;
  screenshot = scripts.screenshot;
  pypulse = pkgs.callPackage ./pypulse {};

  dwmblocks = (pkgs.callPackage ./dwmblocks {}).dwmblocks;
}
