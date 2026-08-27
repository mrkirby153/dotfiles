{pkgs}: {
  pkg,
  binaryName,
  args ? "",
}: let
  binaryNames =
    if builtins.isList binaryName
    then binaryName
    else [binaryName];
  builtArgs =
    if builtins.isList args
    then builtins.concatStringsSep " " args
    else args;
  wrapLines = builtins.concatStringsSep "\\\n      " (
    map (name: ''
      wrapProgram $out/bin/${name} ${builtArgs}
    '')
    binaryNames
  );
in
  pkgs.stdenv.mkDerivation {
    name = "${pkg.name}-wrapped";
    buildInputs = [pkgs.makeWrapper];
    # Copy the original package to the output
    src = pkg;
    installPhase = ''
      mkdir -p $out
      cp -r ${pkg}/. $out/
    '';
    postFixup = ''
      ${wrapLines}
    '';
  }
