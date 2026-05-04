{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

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
