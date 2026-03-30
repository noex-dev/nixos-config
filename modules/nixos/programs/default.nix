{ pkgs, config, ... }:

{
  programs.zsh = {
    enable = true;
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
    btop

    libnotify
    brightnessctl
    wdisplays
  ];
}
