{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    programs.dwmblocks = {
      enable = lib.mkEnableOption "Enable dwmblocks";
      pkg = lib.mkOption {
        type = lib.types.package;
        description = "The dwmblocks package";
        default = pkgs.dwmblocks;
      };
    };
  };

  config = lib.mkIf config.programs.dwmblocks.enable {
    # Create a systemd service for dwmblocks
    systemd.user.services.dwmblocks = {
      Unit = {
        Description = "dwmblocks";
      };
      Service = {
        Type = "simple";
        ExecStart = "${config.programs.dwmblocks.pkg}/bin/dwmblocks";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
