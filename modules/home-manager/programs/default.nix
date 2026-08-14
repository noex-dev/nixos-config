{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "noex";
        email = "github@noex.dev";
      };
      gpg.format = "ssh";
      commit.gpgsign = true;
      safe.directory = "/persist/etc/nixos";
    };

    signing = {
      key = "/run/secrets/git_ssh_key";
      signByDefault = true;
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "github.com" = {
        IdentityFile = "/run/secrets/git_ssh_key";
        IdentitiesOnly = true;
      };

      "git.robo4you.at" = {
        IdentityFile = "/run/secrets/git_ssh_key";
        IdentitiesOnly = true;
      };

      "*" = {
        IdentityFile = [
          "~/.ssh/id_ed25519"
          "~/.ssh/id_rsa"
        ];
      };
    };
  };

  systemd.user.services.bitwarden = {
    Unit = {
      Description = "Bitwarden";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.bitwarden-desktop}/bin/bitwarden";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  home.file.".config/sops/age/keys.txt".text = ''
    AGE-PLUGIN-YUBIKEY-1VPUP2QVZCYWQ0CS7M888S
  '';

  home.packages = with pkgs; [
    protonmail-desktop

    sops
    age-plugin-yubikey

    onlyoffice-desktopeditors
    discord
    element-desktop
    orca-slicer

    vlc
    mpv
    ffmpeg
    yt-dlp
    krita
    anki-bin

    file
    ffmpegthumbnailer
    imagemagick
    poppler-utils

    hyprlock
    wlogout
    swaybg
    mpvpaper

    claude-code
    feishin
    anytype
  ];

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = false;
      background_opacity = 0.7;
      window_padding_width = 10;
    };
  };

  programs.rofi.enable = true;
  programs.home-manager.enable = true;
}
