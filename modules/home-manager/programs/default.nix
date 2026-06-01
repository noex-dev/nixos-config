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

  home.packages = with pkgs; [
    protonmail-desktop
    bitwarden-desktop
    onlyoffice-desktopeditors
    signal-desktop
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
