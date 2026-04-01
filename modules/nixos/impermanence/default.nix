{ inputs, ... }:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  environment.persistence."/persist" = {
    hideMounts = true;

    # --- SYSTEM WIDE PERSISTENCE ---
    directories = [
      # System Services
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/secureboot"

      # Networking & Security
      "/var/lib/bluetooth"
      "/var/lib/networkmanager"
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"

      # Virtualization
      "/var/lib/libvirt"
      "/etc/libvirt"
      "/var/lib/swtpm"
      "/var/log/swtpm"
      "/var/lib/swtpm-localca"
    ];

    files = [
      "/etc/machine-id"
    ];

    # --- USER DATA ---
    users.noel = {
      directories = [
        # Personal Folders
        "Data"
        "Projects"
        "Media"
        "Games"
        "VMs"

        # Communication & Productivity
        ".config/discord"
        ".config/Signal"
        ".config/Bitwarden"
        ".config/Proton Mail"
        ".local/share/Anki2"

        # Tools & System
        ".ssh"
        ".local/share/keyrings"
        ".local/share/zoxide"
        ".config/OrcaSlicer"

        # Gaming
        ".local/share/Steam"
        ".steam"

        # Firefox Persistent Data
        ".mozilla"
      ];

      files = [
        ".zsh_history"
      ];
    };
  };

  programs.fuse.userAllowOther = true;
}
