{
  pkgs,
  writeTextFile,
  runtimeShell,
  lib,
}: let
  shellScript = import ../../lib/shellScript.nix {
    inherit pkgs;
    inherit writeTextFile;
    inherit runtimeShell;
    inherit lib;
  };
in rec {
  screenshot = shellScript {
    name = "screenshot";
    path = ./screenshot;
    deps = with pkgs; [
      curl
      ffmpeg-full
      slop
      maim
      xclip
      libnotify
      feh
      gnugrep
      xorg.xrandr
      imagemagick
      flameshot
    ];
  };
  build_nixos_configuration = shellScript {
    name = "build_nixos_configuration";
    path = ./build_nixos_configuration;
    deps = with pkgs; [
      jq
      nix
      fzf
      git
    ];
  };
  clean_aur_db = shellScript {
    name = "clean_aur_db";
    path = ./clean_aur_db;
    pure = false;
    deps = [clean_aur_signatures];
  };
  clean_aur_signatures = shellScript {
    name = "clean_aur_signatures";
    path = ./clean_aur_signatures;
    pure = false;
  };
  compile = shellScript {
    name = "compile";
    path = ./compile;
    deps = with pkgs; [
      pandoc
      texliveSmall
      gcc
    ];
  };
  dmenu_confirm = shellScript {
    name = "dmenu_confirm";
    path = ./dmenu_confirm;
    deps = with pkgs; [
      aus.dmenu
    ];
  };
  download_reaper = {
    target_path,
    holding_path_root,
    holding_path_fallback,
  }:
    shellScript {
      name = "download_reaper";
      path = ./download_reaper;
      deps = with pkgs; [
        rsync
        libnotify
      ];
      env = {
        TARGET_PATH = target_path;
        HOLDING_PATH_ROOT = holding_path_root;
        HOLDING_PATH_FALLBACK = holding_path_fallback;
      };
    };
  drop_zfs_cache = shellScript {
    name = "drop_zfs_cache";
    path = ./drop_zfs_cache;
    deps = with pkgs; [
      libnotify
    ];
  };
  extract_nsp = shellScript {
    name = "extract_nsp";
    path = ./extract_nsp;
    deps = with pkgs; [
      hactool
    ];
  };
  font-lookup = shellScript {
    name = "font-lookup";
    path = ./font-lookup;
    deps = with pkgs; [
      fontconfig
      findutils
    ];
  };
  mailsync = shellScript {
    name = "mailsync";
    path = ./mailsync;
    deps = with pkgs; [
      findutils
      isync
      notmuch
      pass
      gnused
    ];
  };
  make_apple_ringtone = shellScript {
    name = "make_apple_ringtone";
    path = ./make_apple_ringtone;
    deps = with pkgs; [
      ffmpeg
    ];
  };
  media_control = shellScript {
    name = "media_control";
    path = ./media_control;
    deps = with pkgs; [
      playerctl
      mpd
      mpc-cli
      gnugrep
      gnused
    ];
  };
  modreload = shellScript {
    name = "modreload";
    path = ./modreload;
    deps = with pkgs; [
      kmod
    ];
  };
  multimc_sync_control = shellScript {
    name = "multimc_sync_control";
    path = ./multimc_sync_control;
    deps = with pkgs; [
      curl
      libnotify
    ];
  };
  ocr = shellScript {
    name = "ocr";
    path = ./ocr;
    deps = with pkgs; [
      tesseract
      imagemagick
    ];
  };
  power_menu = shellScript {
    name = "power_menu";
    path = ./power_menu;
    deps = with pkgs; [
      aus.dmenu
      systemd
      dmenu_confirm
    ];
  };
}
