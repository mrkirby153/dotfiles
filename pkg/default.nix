{pkgs}: let
  scripts = pkgs.callPackage ./scripts {};
in {
  screenshot = scripts.screenshot;
}
