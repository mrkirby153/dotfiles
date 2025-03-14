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
        "orbstack"
        "orcaslicer"
        "raycast"
        "readdle-spark"
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
