{
  pkgs,
  config,
  ...
}: let
  allDisplays = ["DP-0" "DP-1" "DP-2" "DP-3" "DP-4" "DP-5" "HDMI-0" "HDMI-1"];
  displaysFunc = import ../../lib/displays.nix {lib = pkgs.lib;};
  displays = displaysFunc.asDisplays allDisplays;
in {
  config.aus = {
    username = "austin";
    home = "/home/austin";
    uid = 1000;

    wallpaper = {
      enable = true;
      path = ./firewatch.jpg;
    };

    dwmblocks.enable = true;

    terminal = {
      enable = true;
      terminal = "ghostty";
      fallback = null;
    };

    programs = {
      screenshot.enable = true;
      scripts.enable = true;
      sxhkd.enable = true;
      dwm = {
        autostart.enable = true;
      };
      autostart.enable = true;
      x11.enable = true;
      shell = {
        enable = true;
        hyfetch.enable = true;
      };
      git = {
        enable = true;
        sign = {
          enable = true;
          key = "90EF2AB021AB6FED";
        };
      };
      ghostty.enable = true;
      attic.enable = true;
      dunst.enable = true;
      picom.enable = true;
      download-reaper = {
        enable = true;
        target_path = "/home/austin/Downloads";
        destination_path = "/autofs/popstar/downloads/";
      };
      restic = {
        backup = {
          enable = true;
          password_file = config.sops.secrets.restic_local.path;
          repo_location = "/run/media/austin/Elements/restic/";
          include = ["/home/austin" "/home/austin/Games" "/mnt/Samsung/Steam/steamapps/compatdata"];
          exclude = ["/home/austin/.cache/" "/home/austin/.local/share/Trash" "/home/austin/.local/share/contianers/storage/overlay/" "/home/austin/.local/share/containers/storage/volumes/"];
          schedule = "*-*-* *:42:00";
          exclude-if-present = [".nobackup"];
          forget = {
            hourly = 24;
            daily = 14;
            weekly = 4;
            monthly = 6;
            yearly = 5;
          };
        };
        offsite = {
          enable = true;
          skip-verify-repo = true;
          password_file = config.sops.secrets.restic_remote_password.path;
          repo_location = config.sops.secrets.restic_remote_repo.path;
          include = config.aus.programs.restic.backup.include;
          exclude = config.aus.programs.restic.backup.exclude ++ ["/home/austin/Downloads/" "/home/austin/Music/"];
          exclude-if-present = config.aus.programs.restic.backup.exclude-if-present ++ [".noremote"];
          forget = {
            last = 5;
          };
        };
      };
      vim.enable = true;
      mail.enable = true;
      nh = {
        enable = true;
        flake = "/home/austin/Development/nix/dotfiles";
      };
      ffsend.enable = true;
    };

    displays.displays = {
      single = {
        keybind = "super + shift + o";
        displays = displays [
          {
            name = "DP-4";
            enable = true;
            primary = true;
            mode = {
              width = 2560;
              height = 1440;
            };
            rate = 144.0;
          }
        ];
      };
      single-alt = {
        keybind = "super + ctrl + shift + o";
        displays = displays [
          {
            name = "DP-2";
            enable = true;
            primary = true;
            mode = {
              width = 2560;
              height = 1440;
            };
            rate = 144.0;
          }
        ];
      };
      dual = {
        keybind = "super + o";
        default = true;
        displays = displays [
          {
            name = "DP-4";
            enable = true;
            primary = true;
            mode = {
              width = 2560;
              height = 1440;
            };
            rate = 144.0;
          }
          {
            name = "DP-2";
            enable = true;
            pos = {
              x = 2560;
              y = 0;
            };
            mode = {
              width = 2560;
              height = 1440;
            };
            rate = 144.0;
          }
        ];
      };
    };
    sops.enable = true;
    nxctl = {
      enable = true;
      line-in = ["Family 17h/19h/1ah HD Audio Controller Analog Stereo:capture_FL" "Family 17h/19h/1ah HD Audio Controller Analog Stereo:capture_FR"];
      speakers = ["Family 17h/19h/1ah HD Audio Controller Analog Stereo:playback_FL" "Family 17h/19h/1ah HD Audio Controller Analog Stereo:playback_FR"];
      headphones = ["HyperX QuadCast Analog Stereo:playback_FL" "HyperX QuadCast Analog Stereo:playback_FR"];
      monitor = 2;
      profiles = {
        activate = {
          display-profile = "single-alt";
          monitor-input = 12; # HDMI-2
        };
        deactivate = {
          display-profile = "dual";
          monitor-input = 15; # DisplayPort-1
        };
      };
    };
  };
  config.sops.secrets = {
    restic_local = {
      sopsFile = ../../secrets/aus-box/restic_passwords.yaml;
    };
    restic_remote_repo = {
      sopsFile = ../../secrets/aus-box/restic_passwords.yaml;
    };
    restic_remote_password = {
      sopsFile = ../../secrets/aus-box/restic_passwords.yaml;
    };
  };
}
