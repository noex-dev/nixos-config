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

    matchBlocks = {
      "github.com" = {
        identityFile = "/run/secrets/git_ssh_key";
        identitiesOnly = true;
      };

      "git.robo4you.at" = {
        identityFile = "/run/secrets/git_ssh_key";
        identitiesOnly = true;
      };

      "*" = {
        identityFile = [
          "~/.ssh/id_ed25519"
          "~/.ssh/id_rsa"
        ];
      };
    };
  };

  home.packages = with pkgs; [
    firefox
    bitwarden-desktop
    signal-desktop
    discord

    btop
    vlc
    mpv
    ffmpeg
    yt-dlp
    krita
    anki-bin

    yazi
    file
    ffmpegthumbnailer
    imagemagick
    poppler-utils
    fzf
    ripgrep

    hyprlock
    wlogout
    swaybg
    mpvpaper

    vscode
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
