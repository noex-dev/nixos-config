{ pkgs, ... }:

{
  imports = [
    ./locale.nix
    ./users.nix
    ./desktop.nix
    ./networking.nix
    ./programs.nix
    ./sops.nix
    ./virtualisation.nix
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    curl
  ];

  system.stateVersion = "25.11";
}
