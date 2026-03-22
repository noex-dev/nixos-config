{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = [
      "hyprland"
      "gtk"
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
  };

  services.dbus.enable = true;
  security.polkit.enable = true;
  programs.dconf.enable = true;

  services.gnome.gnome-keyring.enable = true;

  services.getty.helpLine = "nixos-config by noex; see https://github.com/noex/nixos-config.git";
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = [
      ""
      "@${pkgs.util-linux}/sbin/agetty agetty --skip-login --login-options noel %I $TERM"
    ];
  };

  programs.zsh.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec Hyprland # Wir rufen Hyprland direkt auf
    fi
  '';

  environment.systemPackages = with pkgs; [
    polkit_gnome
    gnome-themes-extra
    papirus-icon-theme
    bibata-cursors
    orchis-theme
    firefox
    xdg-utils
  ];
}
