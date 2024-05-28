{
  pkgs,
  lib,
}: rec {
  domain = "tail7758c.ts.net";
  ips = {
    opnsense = "100.100.95.13";
    opnsense-halcandra = "100.97.200.7";
    gallifrey = "100.117.65.44";
    forgejo = "100.104.27.128";
  };
  hosts = pkgs.lib.mapAttrs (host: ip: {
    inherit ip;
    host = "${host}.${domain}";
  }) ips;
}
