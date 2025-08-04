{lib, ...}: {
  options.aus = {
    programs.shell = {
      enable = lib.mkEnableOption "Enable shell support";
    };
  };

  imports = [
    ./atuin.nix
    ./hyfetch.nix
    ./msc.nix
    ./nix-shell.nix
    ./starship.nix
    ./zsh.nix
  ];
}
