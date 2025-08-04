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
        "teleport"
        "terminal-notifier"
        "syncthing"
        "rustup"
        "protobuf"
      ];
      casks = [
        "bambu-studio"
        "barrier"
        "batfi"
        "calibre"
        "libreoffice"
        "notion-calendar"
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
