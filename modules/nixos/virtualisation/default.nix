{ pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/swtpm-localca 0750 tss tss -"
    "d /var/log/swtpm 0755 qemu-libvirtd libvirtd -"
    "d /var/log/swtpm/libvirt 0755 qemu-libvirtd libvirtd -"
    "d /var/log/swtpm/libvirt/qemu 0755 qemu-libvirtd libvirtd -"
  ];

  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = with pkgs; [
    virt-viewer
    spice-gtk
    virtio-win
  ];
}
