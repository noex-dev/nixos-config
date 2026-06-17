{ config, lib, ... }:

{
  config = lib.mkIf config.noex.vpn.enable {
    sops.secrets.wg_private_key = { };
    sops.secrets.wg_preshared_key = { };

    services.resolved.enable = true;

    networking.wg-quick.interfaces.vpn = {
      address = [ config.noex.vpn.address ];
      dns = [ "10.60.0.1" ];
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
    };
  };
}
