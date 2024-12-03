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
        "barrier"
        "raycast"
        "visual-studio-code"
        "orbstack"
        "readdle-spark"
        "zoom"
      ];
      taps = [
        "homebrew/services"
      ];
      onActivation.cleanup = "zap";
    };
  };
}
