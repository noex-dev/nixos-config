{ pkgs, ... }:

let
  printerIp = "10.40.0.15";
  scanDevice = "airscan:e0:HP ENVY 6000";

  airscanConf = pkgs.writeText "airscan.conf" ''
    [devices]
    "HP ENVY 6000" = http://${printerIp}:8080/eSCL/
  '';

  saneConfig = pkgs.runCommand "sane-config-envy" { } ''
    mkdir -p $out
    cp -rL ${pkgs.sane-backends}/etc/sane.d/. $out/
    chmod -R u+w $out
    cp -rL ${pkgs.sane-airscan}/etc/sane.d/. $out/
    chmod -R u+w $out
    cp -f ${airscanConf} $out/airscan.conf
  '';

  saneLibs = "/run/current-system/sw/lib/sane";

  scan = pkgs.writeShellScriptBin "scan" ''
    export SANE_CONFIG_DIR=${saneConfig}
    export LD_LIBRARY_PATH=${saneLibs}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
    out="''${1:-scan-$(date +%Y%m%d-%H%M%S).png}"
    ${pkgs.sane-backends}/bin/scanimage \
      -d '${scanDevice}' \
      --source Flatbed \
      --resolution 300 \
      --format=png \
      -o "$out"
    echo "→ $out"
  '';

  simple-scan-wrapped =
    pkgs.runCommand "simple-scan-envy"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
      }
      ''
        mkdir -p $out/bin $out/share
        cp -r ${pkgs.simple-scan}/share/. $out/share/
        makeWrapper ${pkgs.simple-scan}/bin/simple-scan $out/bin/simple-scan \
          --set SANE_CONFIG_DIR ${saneConfig} \
          --prefix LD_LIBRARY_PATH : ${saneLibs}
      '';
in
{
  services.printing.enable = true;

  hardware.printers = {
    ensurePrinters = [
      {
        name = "HP_Envy_6000";
        description = "HP ENVY 6000";
        deviceUri = "ipp://${printerIp}/ipp/print";
        model = "everywhere";
      }
    ];
    ensureDefaultPrinter = "HP_Envy_6000";
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
  };

  users.users.noel.extraGroups = [
    "lp"
    "scanner"
  ];

  environment.systemPackages = with pkgs; [
    system-config-printer
    simple-scan-wrapped
    scan
  ];
}
