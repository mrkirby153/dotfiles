{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    aus.programs.scripts = {
      enable = lib.mkEnableOption "Enable scripts";
    };
  };

  config = lib.mkIf config.aus.programs.scripts.enable {
    home.packages = with pkgs.scripts; [
      screenshot
      build_nixos_configuration
      clean_aur_db
      clean_aur_signatures
      compile
      dmenu_confirm
      drop_zfs_cache
      extract_nsp
      font-lookup
      mailsync
      make_apple_ringtone
      media_control
      modreload
      multimc_sync_control
      ocr
      power_menu
    ];
  };
}
