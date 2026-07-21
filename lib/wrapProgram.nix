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
      wrapProgram $out/bin/${name}\
        ${builtArgs}
    '')
    binaryNames
  );
in
  pkg.overrideAttrs (old: {
    buildInputs = (old.buildInputs or []) ++ [pkgs.makeWrapper];
    postFixup = ''
      ${old.postFixup or ""}
      ${wrapLines}
    '';
  })
