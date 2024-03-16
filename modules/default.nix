{...}: {
  imports = [
    ./base.nix
    ./sops.nix
    # Import custom modules
    ./home-manager
    ./displays

    # Import modules for programs
    ./attic.nix
    ./autostart.nix
    ./download_reaper.nix
    ./dunst.nix
    ./dwmblocks
    ./git.nix
    ./mail.nix
    ./picom
    ./restic
    ./screenshot
    ./scripts.nix
    ./shell
    ./sxhkd.nix
    ./vim.nix
    ./wallpaper.nix
    ./x11.nix
  ];
}
