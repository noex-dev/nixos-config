{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p16s-amd-gen1
    ./hardware-configuration.nix

    ../common
    ../../modules/nixos/lanzaboot
    ../../modules/nixos/disko
    ../../modules/nixos/impermanence
    ../../modules/nixos/audio
    ../../modules/nixos/desktop
    ../../modules/nixos/network
    ../../modules/nixos/programs
  ];

  boot.kernelModules = [
    "kvm-amd"
    "thinkpad_acpi"
    "acpi_call"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    acpi_call
  ];

  networking.hostName = "p16s";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.libinput.enable = true;

  services.fprintd.enable = true;

  services.fwupd.enable = true;

  services.upower.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 85;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };
}
