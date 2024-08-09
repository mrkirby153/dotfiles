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
      ];
      casks = [
        "barrier"
        "raycast"
        "visual-studio-code"
      ];
      onActivation.cleanup = "zap";
    };
  };
}
