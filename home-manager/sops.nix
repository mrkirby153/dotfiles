{
  config,
  lib,
  ...
}: 
let
  cfg = config.aus.sops;
  in
{
  options = {
    aus.sops = {
      enable = lib.mkEnableOption "sops";
      keyPath = lib.mkOption {
        type = lib.types.str;
        default = "${config.aus.home}/.ssh/id_ed25519";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.age.sshKeyPaths = [cfg.keyPath];
  };
}
