{...}: {
  imports = [
    ./base.nix
    ./sops.nix
    # Import modules for programs
    ./attic.nix
    ./autostart.nix
    ./download_reaper.nix
    ./dunst.nix
    ./dwmblocks/dwmblocks.nix
    ./git
    ./mail.nix
    ./nh.nix
    ./picom
    ./screenshot
    ./scripts.nix
    ./shell
    ./sxhkd.nix
    ./terminal.nix
    ./vim.nix
    ./wallpaper.nix
    ./x11.nix
  ];
}
