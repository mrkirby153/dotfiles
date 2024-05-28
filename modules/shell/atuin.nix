{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.aus.programs.shell.enable {
    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      flags = [
        "--disable-up-arrow"
      ];
      settings = {
        filter_mode = "host";
        show_preview = true;
        sync_address = "https://atuin.mrkirby153.com";
        sync = {
          records = true;
        };
        daemon = {
          enabled = true;
          socket_path = "/run/user/${toString config.aus.uid}/atuin.socket";
          systemd_socket = true;
        };
      };
    };

    systemd.user.services.atuin-daemon = {
      Unit = {
        Description = "Atuin daemon";
        Requires = ["atuin-daemon.socket"];
      };
      Service = {
        ExecStart = "${lib.getExe pkgs.atuin} daemon";
        Environment = ["ATUIN_LOG=info"];
      };
      Install = {
        Also = ["atuin-daemon.socket"];
        WantedBy = ["default.target"];
      };
    };
    systemd.user.sockets.atuin-daemon = {
      Unit = {
        Description = "Unix socket activation for atuin";
      };
      Socket = {
        ListenStream = "%t/atuin.socket";
        SocketMode = "0600";
        RemoveOnStop = true;
      };
      Install = {
        WantedBy = ["sockets.target"];
      };
    };
  };
}
