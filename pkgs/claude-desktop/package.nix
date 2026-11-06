# Official Claude Desktop (Linux beta), repackaged from Anthropic's apt repo.
#
# Update: look up the newest version/hash with
#   curl -s https://downloads.claude.ai/claude-desktop/apt/stable/dists/stable/main/binary-amd64/Packages \
#     | grep -E '^(Version|SHA256):' | tail -2
# then bump `version` and `hash` (SRI: `nix hash convert --hash-algo sha256 <hex>`).
{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  asar,
  autoPatchelfHook,
  makeShellWrapper,
  wrapGAppsHook3,

  # libraries linked by the electron binary and native modules
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libcap_ng,
  libdrm,
  libgbm,
  libseccomp,
  libxkbcommon,
  nspr,
  nss,
  pango,
  pipewire,
  systemd,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxtst,

  # dlopen'd at runtime
  libGL,
  libayatana-appindicator,
  libnotify,
  libpulseaudio,
  libsecret,
  libuuid,

  # tools the app calls by absolute /usr path (Cowork VM, KWallet, ssh)
  qemu_kvm,
  OVMF,
  virtiofsd,
  openssh,

  # tools the app looks up on PATH
  bubblewrap,
  socat,
  xdg-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "claude-desktop";
  version = "4.23118.0";

  src = fetchurl {
    url = "https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/claude-desktop_${finalAttrs.version}_amd64.deb";
    hash = "sha256-GtmW6MqrBcmzdGRgUcQMtrudhPNxdW8VuNNyiJdRWpc=";
  };

  nativeBuildInputs = [
    dpkg
    asar
    autoPatchelfHook
    makeShellWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libcap_ng
    libdrm
    libgbm
    libseccomp
    libxkbcommon
    nspr
    nss
    pango
    pipewire
    (lib.getLib systemd)
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxtst
    stdenv.cc.cc.lib
  ];

  runtimeDependencies = [
    libGL
    libayatana-appindicator
    libnotify
    libpulseaudio
    libsecret
    libuuid
    (lib.getLib systemd)
  ];

  dontWrapGApps = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --fsys-tarfile $src | tar -x --no-same-owner --no-same-permissions
    # setuid helper is unusable from the store; electron falls back to the userns sandbox
    rm usr/lib/claude-desktop/chrome-sandbox
    runHook postUnpack
  '';

  # Cowork and a few helpers hardcode Debian paths; point them into the store.
  # substituteInPlace --replace-fail aborts the build if a string disappears
  # in a future release, so nothing silently breaks on update.
  postPatch = ''
    res=usr/lib/claude-desktop/resources
    asar extract $res/app.asar app
    rm -rf $res/app.asar $res/app.asar.unpacked

    files=$(grep -rlF -e /usr/bin/qemu-system-x86_64 -e /usr/share/OVMF -e /usr/libexec/virtiofsd \
      -e /usr/bin/busctl -e '"/usr/bin/ssh"' app/.vite/build)
    [ -n "$files" ] || { echo "no files with hardcoded paths found" >&2; exit 1; }
    for f in $files; do
      substituteInPlace "$f" \
        --replace-quiet '"/usr/bin/qemu-system-x86_64"' '"${qemu_kvm}/bin/qemu-system-x86_64"' \
        --replace-quiet '"/usr/share/OVMF/OVMF_CODE_4M.fd"' '"${OVMF.fd}/FV/OVMF_CODE.fd"' \
        --replace-quiet '"/usr/libexec/virtiofsd"' '"${virtiofsd}/bin/virtiofsd"' \
        --replace-quiet '"/usr/bin/busctl"' '"${systemd}/bin/busctl"' \
        --replace-quiet '"/usr/bin/ssh"' '"${openssh}/bin/ssh"'
      # patched sources no longer match their V8 bytecode cache
      rm -f "app/compile-cache/$(basename "$f").x64.jsc"
    done
    for s in ${qemu_kvm}/bin/qemu-system-x86_64 ${OVMF.fd}/FV/OVMF_CODE.fd ${virtiofsd}/bin/virtiofsd; do
      grep -rqF "$s" app/.vite/build || { echo "patch for $s did not apply" >&2; exit 1; }
    done

    asar pack app $res/app.asar --unpack '{*.node,github-mcp-server}'
    rm -rf app
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib
    cp -r usr/lib/claude-desktop $out/lib/
    cp -r usr/share $out/
    rm -rf $out/share/lintian

    # .mcpb/.skill MIME types, normally registered by the postinst script
    install -Dm644 $out/lib/claude-desktop/resources/linux-mime/com.anthropic.Claude.xml \
      $out/share/mime/packages/com.anthropic.Claude.xml

    runHook postInstall
  '';

  postFixup = ''
    makeShellWrapper $out/lib/claude-desktop/claude-desktop $out/bin/claude-desktop \
      "''${gappsWrapperArgs[@]}" \
      --suffix PATH : ${
        lib.makeBinPath [
          bubblewrap
          socat
          openssh
          xdg-utils
        ]
      } \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      `# Without this, Hyprland's render:cm_auto_hdr flips the monitor into HDR` \
      `# (a modeset, i.e. a black flash) whenever the window goes fullscreen.` \
      --add-flags "--disable-features=WaylandWpColorManagerV1"

    substituteInPlace $out/share/applications/com.anthropic.Claude.desktop \
      --replace-fail "Exec=claude-desktop" "Exec=$out/bin/claude-desktop"
  '';

  meta = {
    description = "Official Claude desktop app (Linux beta)";
    homepage = "https://claude.ai/download";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "claude-desktop";
  };
})
