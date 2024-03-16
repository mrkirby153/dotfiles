{
  pkgs, config, lib, ...
}:
{
  options = {
    aus.programs.mail = {
      enable = lib.mkEnableOption "Enable email management";
    };
  };

  config = lib.mkIf config.aus.programs.mail.enable {
    sops.secrets.mail_pass = {
      sopsFile = ../secrets/mailpass.txt;
      format = "binary";
    };

    services.sxhkd.keybindings = {
      "super + shift + m" = "${pkgs.aus.st}/bin/st -c mail ${pkgs.neomutt}/bin/neomutt";
    };
  };
}