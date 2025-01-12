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
      aus.dmenu
      curl
      feh
      ffmpeg-full
      flameshot
      gnugrep
      imagemagick
      libnotify
      maim
      slop
      xclip
      xorg.xrandr
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
      nix-output-monitor
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
  find-store-path-gc-roots = shellScript {
    name = "find_store_path_gc_roots";
    path = ./find_store_path_gc_roots;
    deps = with pkgs; [
      nix
      gawk
      gnugrep
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
      gawk
      perl
      libnotify
    ];
  };
  make_apple_ringtone = shellScript {
    name = "make_apple_ringtone";
    path = ./make_apple_ringtone;
    deps = with pkgs; [
      ffmpeg
      bc
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
      libnotify
      maim
      xclip
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
  st_wrapper = shellScript {
    name = "st_wrapper";
    path = ./st_wrapper;
    pure = false;
  };
  usb_wake_disable = shellScript {
    name = "usb_wake_disable";
    path = ./usb_wake_disable;
    deps = [];
  };
  monitorctl = shellScript {
    name = "monitorctl";
    path = ./monitorctl;
    pure = false;
    deps = with pkgs; [
      ddcutil
      aus.dmenu
      gawk
      gnused
      gnugrep
      kmod
      polkit
    ];
  };
}
