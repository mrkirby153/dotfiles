{
  pkgs,
  lib,
  runtimeShell,
  writeTextFile,
}: {
  name,
  path,
  deps ? [],
  opts ? [],
  pure ? true,
  env ? {},
}: let
  defaultDeps = lib.makeBinPath (with pkgs; [coreutils bash]);
  depsPath = lib.makeBinPath deps;
  realPath =
    if pure
    then "${depsPath}:${defaultDeps}"
    else "${depsPath}:$PATH";
in
  writeTextFile {
    inherit name;
    destination = "/bin/${name}";
    allowSubstitutes = true;
    executable = true;
    text =
      ''
        #!${runtimeShell}
      ''
      + lib.optionalString (opts != []) ''
        ${lib.strings.concatMapStrings (x: "set -o ${x}\n") opts}
      ''
      + lib.optionalString (deps != []) ''
        export PATH="${realPath}"
      ''
      + lib.optionalString (env != []) ''
        ${lib.strings.concatMapStrings (x: "export ${x}\n") (builtins.attrValues (builtins.mapAttrs (n: v: "${n}=\"${v}\"") env))}
      ''
      + ''
        ${builtins.readFile path}
      '';
  }
