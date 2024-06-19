{ pkgs, lib, self, ... }:
{

  config = {
    nixpkgs.hostPlatform = "aarch64-darwin";
    services.nix-daemon.enable = true;
    nix.settings.experimental-features = "nix-command flakes";
    programs.zsh.enable = true;

    system.configurationRevision = self.rev or self.dityRev or null;
    system.stateVersion = 4;
  };
}