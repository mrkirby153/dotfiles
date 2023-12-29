{
  stdenv,
  fetchFromGitHub,
  xorg,
  pkg-config,
  writeTextFile
}: {
  dwmblocks = {
    blocks,
    delimiter ? " | "
  }:
  let
    toC = block: ''
      { "", "${block.command}", ${toString block.interval}, ${toString block.signal} }
      '';

    blockFile = writeTextFile {
      name = "blocks.h";
      text = ''
        static const Block blocks[] = {
          ${builtins.concatStringsSep "," (map toC blocks)}
        };

        static char *delim = "${delimiter}";
        static unsigned int delimLen = ${toString (builtins.stringLength delimiter)};
      '';
    };
  in 
    stdenv.mkDerivation {
      name = "dwmblocks";
      version = "1.0.0";
      src = fetchFromGitHub {
        owner = "torrinfail";
        repo = "dwmblocks";
        rev = "a933ce0d6109524b393feb3e7156cbf0de88b42c";
        sha256 = "sha256-u94wXumfZQinK7JHAs9tIUMcrn50pTpv5xGL5hhAOqE=";
      };
      buildInputs = [xorg.libX11 pkg-config];
      makeFlags = ["PREFIX=$(out)"];
      patches = [./cmdlength.patch ./strip_newlines.patch];
      preBuild = ''
      echo ${blockFile}
        cp ${blockFile} blocks.h
      '';
    };
}
