{...}: {
  imports = [
    ./base.nix
    ./sops.nix
    # Import custom modules
    ./home-manager
    ./displays

    # Import modules for programs
    ./screenshot
    ./scripts.nix
    ./download_reaper.nix
    ./sxhkd.nix
    ./dwmblocks
    ./x11.nix
    ./shell
    ./git.nix
    ./autostart.nix
    ./attic.nix
    ./dunst.nix
  ];
}
