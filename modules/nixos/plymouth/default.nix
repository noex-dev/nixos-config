{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{

  boot.plymouth = {
    enable = true;
    theme = "mac-style";
    themePackages = [
      inputs.mac-style-plymouth.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  boot.consoleLogLevel = 0;
  boot.kernelParams = [
    "quiet"
    "splash"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    "vt.global_cursor_default=0"
  ];

  boot.initrd.kernelModules = lib.optionals (!config.noex.hardware.hasNvidia) [ "amdgpu" ];
}
