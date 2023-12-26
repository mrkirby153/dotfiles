{
  config,
  ...
}:
{
  config = {
    sops.secrets.screenshot_key = {
      sopsFile = ../../secrets/screenshot_key.txt;
      format = "binary";
      path = "${config.aus.home}/.screenshot_key";
    };
  };
}