{ inputs, ... }:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/networkmanager"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "etc/ssh"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
