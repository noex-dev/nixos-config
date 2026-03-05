{ pkgs, config, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases = {
      kplay = "mpv --vo=tct --panscan=1.0";
    };

    interactiveShellInit = ''
      use() {
        nix shell "nixpkgs#$1" "''${@:2}"
      }
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  virtualisation.docker.enable = true;

  services.tailscale.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    tree
    curl

    swaynotificationcenter
    libnotify
    brightnessctl
    wdisplays

    davinci-resolve
    bambu-studio
  ];
}
