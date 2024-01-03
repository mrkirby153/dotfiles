{
  stdenv,
  fetchFromGitHub,
  xorg,
  pkg-config,
  writeTextFile,
}: {
  dwmblocks = {
    blocks,
    delimiter ? " | ",
  }: let
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
        static unsigned int delimLen = ${toString ((builtins.stringLength delimiter) + 1)};
      '';
    };
  in
    stdenv.mkDerivation {
      name = "dwmblocks";
      version = "1.0.0";
      src = fetchFromGitHub {
        owner = "mrkirby153";
        repo = "dwmblocks";
        rev = "cab6979eae0d5761b316baa2ee464b87f86fced8";
        sha256 = "sha256-FnxQ5bfIs3qg9ZMhQSuGd9TJsEeAhJqmQ8XReFlPqG0=";
      };
      buildInputs = [xorg.libX11 pkg-config];
      makeFlags = ["PREFIX=$(out)"];
      preBuild = ''
        cp ${blockFile} blocks.h
      '';
    };
}
