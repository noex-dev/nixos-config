{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../common
    ../../modules/nixos/plymouth
    ../../modules/nixos/lanzaboot
    ../../modules/nixos/disko
    ../../modules/nixos/impermanence
    ../../modules/nixos/audio
    ../../modules/nixos/desktop
    ../../modules/nixos/virtualisation
    ../../modules/nixos/network
    ../../modules/nixos/programs
    ../../modules/nixos/printing
  ];

  noex.hardware.hasNvidia = true;

  networking.hostName = "pc";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  home-manager.users.noel = {
    imports = [ ./monitor.nix ];
  };

  boot.initrd.luks.devices."crypted" = {
    device = "/dev/disk/by-partlabel/disk-main-luks";
    crypttabExtraOpts = [ "tpm2-device=auto" ];
  };
}
