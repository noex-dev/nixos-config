{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
        user = "greeter";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      hyprland = {
        default = [
          "gtk"
          "hyprland"
        ];
      };
    };
  };

  xdg.mime.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
  };

  services.dbus.enable = true;
  programs.dconf.enable = true;
  services.gnome.gnome-keyring.enable = true;

  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, user) {
      if (action.id == "org.libvirt.unix.manage" &&
          user.isInGroup("libvirtd")) {
        return polkit.Result.YES;
      }
    });
  '';

  environment.systemPackages = with pkgs; [
    hyprpolkitagent
    gnome-themes-extra
    papirus-icon-theme
    bibata-cursors
    orchis-theme
    firefox
    xdg-utils
  ];
}
