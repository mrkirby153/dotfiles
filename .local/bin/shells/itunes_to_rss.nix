{
  pkgs ?
    import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/d1c454a3eb6d2aa923c1217f15c7adbfcb802f3c.tar.gz") {
    },
}: let
  my-packages = ps:
    with ps; [
      requests
    ];
in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      (python3.withPackages my-packages)
    ];
  }
