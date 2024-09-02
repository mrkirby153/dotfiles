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
      ];
      casks = [
        "barrier"
        "raycast"
        "visual-studio-code"
        "orbstack"
      ];
      taps = [
        "homebrew/services"
      ];
      onActivation.cleanup = "zap";
    };
  };
}
