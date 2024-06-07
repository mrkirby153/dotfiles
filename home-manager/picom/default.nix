{
  lib,
  config,
  ...
}: {
  options = {
    aus.programs.picom = {
      enable = lib.mkEnableOption "picom";
    };
  };
  config = lib.mkIf config.aus.programs.picom.enable {
    systemd.user.services = {
      "picom" = {
        Unit = {
          Description = "Picom compositor";
        };
        Service = {
          Type = "simple";
          ExecStart = "/sbin/picom --config ${./picom.conf}";
        };
        Install.WantedBy = ["graphical-session.target"];
      };
    };
  };
}
