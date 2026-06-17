{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.noex.vpn;
  dnsServer = "10.10.0.5";
  splitDomain = "~noex.dev";
in
{
  config = lib.mkIf cfg.enable {
    sops.secrets.wg_private_key = { };
    sops.secrets.wg_preshared_key = { };

    services.resolved.enable = true;

    networking.wg-quick.interfaces.vpn = {
      address = [ cfg.address ];
      privateKeyFile = config.sops.secrets.wg_private_key.path;

      peers = [
        {
          publicKey = "1o7FJrix5v272SdHiTr9g0KMLc/mJUXUXFQjdI2ZLQg=";
          presharedKeyFile = config.sops.secrets.wg_preshared_key.path;
          endpoint = "vpn.noex.dev:51820";

          allowedIPs = [ "10.0.0.0/8" ];
          persistentKeepalive = 25;
        }
      ];

      postUp = ''
        ${pkgs.systemd}/bin/resolvectl dns vpn ${dnsServer}
        ${pkgs.systemd}/bin/resolvectl domain vpn '${splitDomain}'
      '';
    };
  };
}
