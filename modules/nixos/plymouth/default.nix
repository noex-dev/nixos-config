{
  config,
  pkgs,
  inputs,
  ...
}:
{

  boot.plymouth = {
    enable = true;
    theme = "mac-style";
    themePackages = [
      inputs.mac-style-plymouth.packages.${pkgs.system}.default
    ];
  };

  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    "vt.global_cursor_default=0"
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];
}
