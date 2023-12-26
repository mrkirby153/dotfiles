{
  config,
  lib,
  ...
}:
{

  options = {
    aus.sops = {
      keyPath = lib.mkOption {
        type = lib.types.str;
        default = "${config.aus.home}/.ssh/id_ed25519";
      };
    };
  };

  config = {
    sops.age.sshKeyPaths = [config.aus.sops.keyPath];
  };
}