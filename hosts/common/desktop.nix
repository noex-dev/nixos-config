{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services.getty.helpLine = "nixos-config by Lukasxlama; see https://github.com/Lukasxlama/nixos-config.git";
  
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = [
      ""
      "@${pkgs.util-linux}/sbin/agetty agetty --skip-login --login-options lukas %I $TERM"
    ];
  };

  programs.zsh.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec start-hyprland
    fi
  '';

  services.dbus.enable = true;
  security.pam.services.hyprlock = {};

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
    };
  };

  environment.systemPackages = with pkgs; [
    polkit_gnome
    gnome-themes-extra
    papirus-icon-theme
    bibata-cursors
    orchis-theme
  ];
}
