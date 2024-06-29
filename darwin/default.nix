{
  pkgs,
  lib,
  self,
  ...
} @ inputs: {
  config = {
    nixpkgs.hostPlatform = "aarch64-darwin";
    services.nix-daemon.enable = true;
    nix.settings = {
      experimental-features = "nix-command flakes";
      trusted-users = ["austin" "root"];
      auto-optimise-store = true;
    };
    programs.zsh.enable = true;

    nixpkgs.overlays = [
      inputs.my-nixpkgs.overlays.default
      self.overlays.pkgs
      inputs.attic.overlays.default
      inputs.atuin.overlays.default
    ];

    system.configurationRevision = self.rev or self.dityRev or null;
    system.stateVersion = 4;
  };

  imports = [
    ./homebrew.nix
  ];
}
