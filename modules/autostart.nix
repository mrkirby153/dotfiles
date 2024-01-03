{
  pkgs,
  config,
  lib,
  ...
}: let
  mkAutostartEntry = procName: command: "${pkgs.procps}/bin/pidof ${procName} || ${pkgs.util-linux}/bin/setsid -f ${command}";
  mkPgrepAutostartEntry = procName: command: "${pkgs.procps}/bin/pgrep -u $UID -x ${procName} || ${pkgs.util-linux}/bin/setsid -f ${command}";

  ckb_start = pkgs.writeShellScriptBin "ckb_start" ''
    if lsusb | grep "Corsair .* Keyboard" >> /dev/null
    then
      if ps -C ckb-next >> /dev/null
      then
        echo "ckb-next is already running"
      else
        ckb-next -b &
        disown
      fi
    fi
  '';
in {
  options = {
    aus.programs.autostart = {
      enable = lib.mkEnableOption "Enable autostart";
    };
  };
  config = lib.mkIf config.aus.programs.autostart.enable {
    aus.programs.dwm.autostart = {
      non-blocking = [
        "numlockx"
        (mkAutostartEntry "DiscordCanary" "discord-canary --ignore-gpu-blocklist --disable-features=UseOzonePlatform --enable-features=VaapiVideoDecoder --use-gl=desktop --enable-gpu-rasterization --enable-zero-copy")
        (mkAutostartEntry "spotify" "spotify")
        (mkAutostartEntry "1password" "1password --silent")
        (mkPgrepAutostartEntry "redshift-gtk" "redshift-gtk")
        (mkAutostartEntry "parcellite" "${pkgs.parcellite}/bin/parcellite -n")
        (mkAutostartEntry "udiskie" "${pkgs.udiskie}/bin/udiskie")
        "${ckb_start}/bin/ckb_start"
        "setxkbmap -option compose:alt"
        "dwmc xrdb"
      ];
    };

    systemd.user.services = {
      "xfce-polkit" = {
        Unit = {
          Description = "Polkit authentication agent";
        };
        Service = {
          Type = "simple";
          ExecStart = "/usr/lib/xfce-polkit/xfce-polkit";
        };
        Install.WantedBy = ["graphical-session.target"];
      };
      "geoclue-agent" = {
        Unit = {
          Description = "Geoclue agent";
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.geoclue2-with-demo-agent}/libexec/geoclue-2.0/demos/agent";
        };
        Install.WantedBy = ["graphical-session.target"];
      };
    };
  };
}
