{...}: {
  imports = [
    ./base.nix
    ./sops.nix
    # Import modules for programs
    ./attic.nix
    ./autostart.nix
    ./compose.nix
    ./dunst.nix
    ./dwmblocks/dwmblocks.nix
    ./ffsend.nix
    ./ghostty.nix
    ./git
    ./mail.nix
    ./nh.nix
    ./picom
    ./rofi
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
