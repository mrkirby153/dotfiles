{pkgs}: rec {
  dmenu-rofi = pkgs.callPackage ./dmenu-rofi.nix {};
  scripts = pkgs.callPackage ./scripts {};
  screenshot = scripts.screenshot;
  pypulse = pkgs.callPackage ./pypulse {};

  dwmblocks = (pkgs.callPackage ./dwmblocks {}).dwmblocks;
}
