{ config, pkgs, ... }:

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

      "10.30.0.*" = {
        User = "root";
        IdentityAgent = "none";
        IdentityFile = "~/.ssh/id_ed25519_sk_yk5";
        IdentitiesOnly = true;
        ControlMaster = "auto";
        ControlPath = "~/.ssh/cm-%r@%h:%p";
        ControlPersist = "10m";
      };
    };
  };

  home.file.".kube/kube.yaml".source = config.lib.file.mkOutOfStoreSymlink "/run/secrets/kubeconfig";

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
    (anytype.overrideAttrs (old: {
      node_modules = old.node_modules.overrideAttrs {
        outputHash = "sha256-/rHV3hmqAGGhp+x56u49+ZYm8YiV4ie0R5FIHlSguz4=";
      };
    }))

    # for school
    qtcreator

    bitwig-studio
    guitarix
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

  programs.opencode = {
    enable = true;
    package = pkgs.opencode.overrideAttrs (old: {
      node_modules = old.node_modules.overrideAttrs {
        outputHash = "sha256-prx9dX7kUvs/E3zopkaPk5LXh3xJAy5sZeum/W8L7cA=";
      };
    });
    settings = {
      model = "futurelab/qwen3.8-flash-next";
      provider.futurelab = {
        npm = "@ai-sdk/openai-compatible";
        name = "Futurelab";
        options = {
          baseURL = "https://futurelab.robo4you.at/v1";
          apiKey = "{file:/run/secrets/r4u_aqueduct_api_key}";
        };
        models."qwen3.8-flash-next".name = "Qwen 3.8 Flash Next";
      };
    };
  };

  programs.rofi.enable = true;
  programs.home-manager.enable = true;
}
