{ inputs, ... }:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/networkmanager"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/ssh"
      "/etc/secureboot"
    ];
    files = [
      "/etc/machine-id"
    ];

    users.noel = {
      directories = [
        "Documents"
        "Downloads"
        "Pictures"
        "Music"
        "Videos"

        ".mozilla"
        ".ssh"
        ".local/share/keyrings"
        ".config/discord"
        ".config/Signal"
        ".config/Bitwarden"
        ".local/share/Anki2"
        ".local/share/Steam"
        ".steam"
      ];
      files = [
        ".zsh_history"
      ];
    };
  };

  programs.fuse.userAllowOther = true;
}
