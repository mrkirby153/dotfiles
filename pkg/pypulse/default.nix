{ pkgs, stdenv }:
let
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    pulsectl
    notify2
  ]);

in 
stdenv.mkDerivation {
  pname = "pypulse";
  version = "1.0.0";
  src = ./pypulse.py;
  dontUnpack = true;
  buildInputs = [ pythonEnv ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/pypulse
    chmod +x $out/bin/pypulse
  '';
}