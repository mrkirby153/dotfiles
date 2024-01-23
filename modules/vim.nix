{ pkgs, lib, config, my-nvim, ...}:
let
  kirby-nvim = my-nvim.packages.${pkgs.stdenv.system}.default;
in
{
  options.aus.programs.vim.enable = lib.mkEnableOption "Enable vim";

  config = lib.mkIf config.aus.programs.vim.enable {
    home.packages = [
      kirby-nvim
    ];
    programs.zsh.sessionVariables = {
      EDITOR = "${kirby-nvim}/bin/nvim";
      VISUAL = "${kirby-nvim}/bin/nvim";
    };
  };
}