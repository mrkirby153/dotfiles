{
  pkgs,
  lib,
  config,
  aus,
  ...
}: let
  cfg = config.aus.nxctl;
  nxctl = aus.lib.shellScript {
    name = "nxctl";
    path = ./nxctl;
    deps = with pkgs; [
      pkgs.aus.dmenu
      config.aus.displays.pkg
      jack1
      ddcutil
      pipewire.jack
    ];
    pure = false;
    env = {
      LINE_IN = cfg.line-in;
      SPEAKERS = cfg.speakers;
      HEADPHONES = cfg.headphones;
      DISPLAY_ACTIVE = cfg.profiles.activate.display-profile;
      DISPLAY_INACTIVE = cfg.profiles.deactivate.display-profile;
      MONITOR_NUM = cfg.monitor;
      COMPUTER_INPUT = cfg.profiles.deactivate.monitor-input;
      SWITCH_INPUT = cfg.profiles.activate.monitor-input;
    };
  };

  profileType = lib.types.submodule {
    options = {
      display-profile = lib.mkOption {
        type = lib.types.str;
        description = "The display profile to switch to";
      };
      monitor-input = lib.mkOption {
        type = lib.types.int;
        description = "The input to switch the monitor to";
      };
    };
  };

  activate-keybind = {
    "${cfg.keybinds.activate}" = "${nxctl}/bin/nxctl activate";
  };
  deactivate-keybind = {
    "${cfg.keybinds.deactivate}" = "${nxctl}/bin/nxctl deactivate";
  };
in {
  options.aus.nxctl = {
    enable = lib.mkEnableOption "Enable nxctl";
    line-in = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "The names of the line-in JACK ports";
    };
    speakers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "The names of the speaker JACK ports";
    };
    headphones = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "The names of the headphone JACK ports";
    };
    monitor = lib.mkOption {
      type = lib.types.int;
      description = "The monitor number to switch the input of";
    };
    profiles = {
      activate = lib.mkOption {
        type = profileType;
        description = "The profile switched to when activating";
      };
      deactivate = lib.mkOption {
        type = profileType;
        description = "The profile switched to when deactivating";
      };
    };
    pkg = lib.mkOption {
      type = lib.types.package;
      default = nxctl;
    };
    keybinds = {
      activate = lib.mkOption {
        type = lib.types.str;
        description = "The keybind to activate nxctl";
        default = "";
      };
      deactivate = lib.mkOption {
        type = lib.types.str;
        description = "The keybind to deactivate nxctl";
        default = "";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.aus.displays.displays != {};
        message = "No display profiles configured";
      }
      {
        assertion = builtins.elem cfg.profiles.activate.display-profile (pkgs.lib.attrNames config.aus.displays.displays);
        message = "Activation display profile \"${cfg.profiles.activate.display-profile}\" is not configured";
      }
      {
        assertion = builtins.elem cfg.profiles.activate.display-profile (pkgs.lib.attrNames config.aus.displays.displays);
        message = "Computer profile \"${cfg.profiles.activate.display-profile}\" is not configured";
      }
    ];
    home.packages = [
      cfg.pkg
    ];
    services.sxhkd.keybindings =
      (
        if cfg.keybinds.activate != ""
        then activate-keybind
        else {}
      )
      // (
        if cfg.keybinds.deactivate != ""
        then deactivate-keybind
        else {}
      );
  };
}
