{ pkgs, lib, ...}:
{
  config = {
    homebrew = {
      enable = true;
      brews = [

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