{...}: {
  imports = [
    ./base.nix
    ./sops.nix
    # Import custom modules
    ./home-manager/autostart.nix
    ./displays

    # Import modules for programs
    ./screenshot
    ./scripts.nix
    ./download_reaper.nix
    ./sxhkd.nix
  ];
}
