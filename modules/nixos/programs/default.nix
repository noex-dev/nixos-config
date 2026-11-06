{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  # Claude Desktop downloads its own checksum-pinned Claude Code binary
  # (generic glibc ELF) into ~/.config/Claude; nix-ld lets it run unpatched.
  programs.nix-ld.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  virtualisation.docker.enable = true;

  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    bitwarden-desktop

    tree
    curl
    btop

    libnotify
    brightnessctl
    wdisplays
  ];
}
