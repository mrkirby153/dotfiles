{...}: {
  imports = [
    ./base.nix
    ./sops.nix

    ./screenshot
    ./scripts.nix
    ./download_reaper.nix
    ./sxhkd.nix
  ];
}
