{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../common
    ../../modules/nixos/disko
    ../../modules/nixos/impermanence
    ../../modules/nixos/audio
    ../../modules/nixos/desktop
    ../../modules/nixos/virtualisation
    ../../modules/nixos/network
    ../../modules/nixos/programs
  ];

  networking.hostName = "pc";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  home-manager.users.noel = {
    imports = [ ./monitor.nix ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}
