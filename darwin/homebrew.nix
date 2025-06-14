{
  pkgs,
  lib,
  ...
}: {
  config = {
    homebrew = {
      enable = true;
      brews = [
        "gpg"
        "hyfetch"
        "teleport"
        "terminal-notifier"
        "syncthing"
        "rustup"
        "protobuf"
      ];
      casks = [
        "bambu-studio"
        "barrier"
        "calibre"
        "libreoffice"
        "orbstack"
        "orcaslicer"
        "raycast"
        "readdle-spark"
        "spotify"
        "visual-studio-code"
        "zoom"
      ];
      taps = [
        "homebrew/services"
      ];
      onActivation.cleanup = "zap";
    };
  };
}
