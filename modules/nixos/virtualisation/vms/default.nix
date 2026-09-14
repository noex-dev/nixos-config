{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.noex.vms;

  tiny11Iso = pkgs.fetchurl {
    url = "https://archive.org/download/tiny11_25H2/tiny11_25H2_Nov25.iso";
    hash = "sha256-eySBWEVoSt1yUICLOwAnuk6Uz1LGLp70DVuWXdME1so=";
  };

  cdrom = dev: iso: extra: ''
    <disk type="file" device="cdrom">
          <driver name="qemu" type="raw"/>
          <source file="${iso}"/>
          <target dev="${dev}" bus="sata"/>
          <readonly/>
          ${extra}
        </disk>'';

  tiny11Domain =
    name: uuid: mac: extraDevices:
    pkgs.replaceVars ./tiny11.xml {
      inherit
        name
        uuid
        mac
        extraDevices
        ;
    };

  tiny11Volume =
    name: capacity: backingStore:
    pkgs.replaceVars ./volume-tiny11.xml {
      inherit name backingStore;
      capacity = toString capacity;
    };

  tiny11Base = tiny11Domain "tiny11-base" "2629d02d-85ad-48bd-8e96-22f190b857ad" "52:54:00:68:95:00" (
    lib.optionalString cfg.tiny11.installMode (
      cdrom "sda" tiny11Iso ''<boot order="1"/>'' + "\n    " + cdrom "sdb" pkgs.virtio-win.src ""
    )
  );

  tiny11School =
    tiny11Domain "tiny11-school" "139eb486-590a-4883-a9d7-df94f3f044ea" "52:54:00:e5:70:a5"
      "";

  schoolEnabled = !cfg.tiny11.installMode;
in
{
  imports = [ inputs.nixvirt.nixosModules.default ];

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "C+ /var/lib/libvirt/qemu/MSDM 0400 root root - /sys/firmware/acpi/tables/MSDM"
    ];

    virtualisation.libvirt = {
      enable = true;

      connections."qemu:///system" = {
        networks = [
          {
            definition = ./network-default.xml;
            active = true;
            restart = false;
          }
        ];

        pools = [
          {
            definition = ./pool-default.xml;
            active = true;
            volumes = [
              { definition = tiny11Volume "tiny11-base" 64 ""; }
            ]
            ++ lib.optional schoolEnabled {
              definition = tiny11Volume "tiny11-school" 128 ''
                <backingStore>
                    <path>/var/lib/libvirt/images/tiny11-base.qcow2</path>
                    <format type="qcow2"/>
                  </backingStore>'';
            };
          }
        ];

        domains =
          lib.optional cfg.tiny11.installMode {
            definition = tiny11Base;
            restart = false;
          }
          ++ lib.optional schoolEnabled {
            definition = tiny11School;
            restart = false;
          };
      };
    };
  };
}
