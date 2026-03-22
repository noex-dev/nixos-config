{ inputs, ... }:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/networkmanager"
      "/etc/NetworkManager/system-connections"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/libvirt"
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

        ".ssh"
        ".local/share/keyrings"
        ".config/mozilla/firefox"
        ".config/OrcaSlicer"
        ".config/discord"
        ".config/Signal"
        ".config/Bitwarden"
        ".local/share/Anki2"
        ".local/share/Steam"
        ".var/app"
        ".steam"
      ];
      files = [
        ".zsh_history"
      ];
    };
  };

  programs.fuse.userAllowOther = true;
}
