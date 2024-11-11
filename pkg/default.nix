{pkgs}: rec {
  scripts = pkgs.callPackage ./scripts {};
  screenshot = scripts.screenshot;
  pypulse = pkgs.callPackage ./pypulse {};

  dwmblocks = (pkgs.callPackage ./dwmblocks {}).dwmblocks;
}
