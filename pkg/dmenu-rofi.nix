{
  stdenv,
  rofi,
  makeWrapper,
  lib,
}:
stdenv.mkDerivation {
  name = "rofi-dmenu";
  version = "1.0.0";

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${rofi}/bin/rofi $out/bin/dmenu \
      --add-flags "-dmenu"
  '';

  meta = with lib; {
    description = "Rofi wrapped as dmenu";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "dmenu";
    priority = 0;
  };
}
