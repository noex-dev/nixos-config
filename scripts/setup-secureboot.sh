#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
LUKS_DEV="/dev/disk/by-partlabel/disk-main-luks"
PERSIST_PATH="/persist/etc/secureboot"
PKI_PATH="/etc/secureboot"
PCRS="0+2+7"

if [[ $EUID -ne 0 ]]; then
  echo "Error: This script must be run as root."
  exit 1
fi

usage() {
  cat <<EOF
Usage: setup-secureboot <command>

Commands:
  keys    Phase 1: enroll Secure Boot keys into the firmware (requires Setup Mode).
          Reuses keys from $PERSIST_PATH if present, otherwise creates them.
          Afterwards: run 'nixos-rebuild switch', reboot, ENABLE Secure Boot in
          the BIOS, boot (enter the LUKS passphrase manually once), then 'tpm'.
  tpm     Phase 2: (re-)enroll the TPM2 keyslot for LUKS auto-unlock (PCRs $PCRS).
          Run this ONLY after Secure Boot is confirmed active, otherwise PCR 7
          changes on the next boot and auto-unlock breaks.
  status  Show current Secure Boot + TPM state, plus the resolved key paths.
EOF
}

# ---------------------------------------------------------------------------
# sbctl plumbing: pin every invocation to one config so that create-keys,
# enroll-keys and verify cannot disagree about where the keys live.
# ---------------------------------------------------------------------------
SBCTL_CONF=""
HAVE_CONFIG_FLAG=0
HAVE_LANDLOCK_FLAG=0
DID_MOUNT=0

detect_sbctl_flags() {
  local help
  help="$(sbctl --help 2>&1 || true)"
  grep -q -- '--config' <<<"$help" && HAVE_CONFIG_FLAG=1
  grep -q -- '--disable-landlock' <<<"$help" && HAVE_LANDLOCK_FLAG=1
}

write_sbctl_conf() {
  ((HAVE_CONFIG_FLAG)) || return 0
  SBCTL_CONF="$(mktemp -t sbctl.conf.XXXXXX)"
  cat >"$SBCTL_CONF" <<EOF
---
keydir: $PKI_PATH/keys
guid: $PKI_PATH/GUID
files_db: $PKI_PATH/files.json
bundles_db: $PKI_PATH/bundles.json
landlock: false
db_additions:
  - microsoft
EOF
}

sb() {
  local -a pre=()
  ((HAVE_CONFIG_FLAG)) && pre+=(--config "$SBCTL_CONF")
  ((HAVE_LANDLOCK_FLAG)) && pre+=(--disable-landlock)
  sbctl ${pre[@]+"${pre[@]}"} "$@"
}

ensure_mount() {
  mkdir -p "$PERSIST_PATH"
  [[ "$PKI_PATH" == "$PERSIST_PATH" ]] && return 0
  mkdir -p "$PKI_PATH"
  if mountpoint -q "$PKI_PATH"; then
    return 0
  fi
  mount --bind "$PERSIST_PATH" "$PKI_PATH"
  DID_MOUNT=1
}

normalize_layout() {
  local k="$PKI_PATH/keys"

  if [[ -f "$k/PK/PK.key" ]]; then
    return 0
  fi

  if [[ -f "$PKI_PATH/PK/PK.key" ]]; then
    echo "Found flat key export -> moving into $k/"
    mkdir -p "$k"
    local d
    for d in PK KEK db custom; do
      [[ -e "$PKI_PATH/$d" ]] && mv "$PKI_PATH/$d" "$k/"
    done
    return 0
  fi

  if [[ -f /var/lib/sbctl/keys/PK/PK.key ]]; then
    echo "Found keys in /var/lib/sbctl -> importing into $PKI_PATH/"
    mkdir -p "$k"
    cp -a /var/lib/sbctl/keys/. "$k/"
    [[ -f /var/lib/sbctl/GUID ]] && cp -a /var/lib/sbctl/GUID "$PKI_PATH/GUID"
    return 0
  fi

  if [[ -f /usr/share/secureboot/keys/PK/PK.key ]]; then
    echo "Found keys in /usr/share/secureboot -> importing into $PKI_PATH/"
    mkdir -p "$k"
    cp -a /usr/share/secureboot/keys/. "$k/"
    [[ -f /usr/share/secureboot/GUID ]] && cp -a /usr/share/secureboot/GUID "$PKI_PATH/GUID"
    return 0
  fi

  return 0
}

have_keys() { [[ -f "$PKI_PATH/keys/PK/PK.key" && -f "$PKI_PATH/keys/db/db.key" ]]; }

sbctl_init() {
  command -v sbctl >/dev/null || {
    echo "Error: sbctl not found in PATH."
    exit 1
  }
  detect_sbctl_flags
  ensure_mount
  normalize_layout
  write_sbctl_conf
  trap 'rm -f "${SBCTL_CONF:-}"' EXIT
}

in_setup_mode() {
  local json
  if json="$(sb --json status 2>/dev/null)"; then
    grep -q '"setup_mode":[[:space:]]*true' <<<"$json" && return 0
    grep -q '"setup_mode":[[:space:]]*false' <<<"$json" && return 1
  fi

  sb status 2>/dev/null | grep -i "Setup Mode" | grep -qi "enabled"
}

# ---------------------------------------------------------------------------
# Commands
# ---------------------------------------------------------------------------
cmd_keys() {
  sbctl_init

  if ! in_setup_mode; then
    echo "Error: System is not in Setup Mode."
    echo "Reboot into the firmware (systemctl reboot --firmware-setup),"
    echo "clear/reset the Secure Boot keys, and try again."
    exit 1
  fi

  if have_keys; then
    echo "Reusing existing keys from $PERSIST_PATH."
  else
    echo "No existing keys found -> creating new ones."
    sb create-keys
    normalize_layout
    if ! have_keys; then
      echo
      echo "Error: sbctl created keys but not where expected ($PKI_PATH/keys)."
      echo "Found instead:"
      find /var/lib/sbctl /usr/share/secureboot "$PKI_PATH" \
        -maxdepth 4 -name '*.key' 2>/dev/null || true
      exit 1
    fi
  fi

  echo "Enrolling keys into the EFI variables..."
  sb enroll-keys --microsoft

  echo
  echo "Verifying signatures of installed EFI binaries..."
  sb verify || true

  echo
  echo "== Phase 1 done. =="
  echo "Next steps:"
  echo "  1. sudo nixos-rebuild switch   (lanzaboote signs the boot chain)"
  echo "  2. sudo sbctl verify           (everything must be signed)"
  echo "  3. Reboot and ENABLE Secure Boot in the BIOS."
  echo "  4. Boot (enter the LUKS passphrase manually this one time)."
  echo "  5. Verify: bootctl status  ->  'Secure Boot: enabled'"
  echo "  6. Run: sudo nix run .#setup-secureboot -- tpm"
  if ((DID_MOUNT)); then
    echo
    echo "NOTE: $PKI_PATH is a bind mount created by this script and will not"
    echo "      survive a reboot. Make it declarative, e.g.:"
    echo "        environment.persistence.\"/persist\".directories = [ \"/etc/secureboot\" ];"
    echo "      Otherwise lanzaboote cannot sign on the next rebuild."
  fi
}

cmd_tpm() {
  if ! bootctl status 2>/dev/null | grep -qi "Secure Boot: enabled"; then
    echo "WARNING: Secure Boot is not reported as active."
    echo "Enrolling now binds the TPM to the wrong PCR 7 value and auto-unlock"
    echo "will fail once Secure Boot is enabled."
    read -rp "Continue anyway? [y/N] " ans
    [[ "$ans" == "y" || "$ans" == "Y" ]] || exit 1
  fi
  echo "Wiping any stale TPM2 keyslot (bound to the old TPM)..."
  systemd-cryptenroll --wipe-slot=tpm2 "$LUKS_DEV" || true
  echo "Enrolling new TPM2 keyslot (PCRs $PCRS)..."
  systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs="$PCRS" "$LUKS_DEV"
  echo
  echo "== Phase 2 done. == Reboot to confirm automatic LUKS unlock."
}

cmd_status() {
  sbctl_init

  sb status || true
  echo
  bootctl status 2>/dev/null | grep -i "secure boot" || true

  echo
  echo "Key storage:"
  echo "  persist: $PERSIST_PATH"
  echo "  pki:     $PKI_PATH$([[ "$PKI_PATH" != "$PERSIST_PATH" ]] &&
    { mountpoint -q "$PKI_PATH" && echo "  (bind-mounted)" || echo "  (NOT mounted)"; })"
  if have_keys; then
    echo "  keys:    OK ($PKI_PATH/keys/{PK,KEK,db})"
  else
    echo "  keys:    MISSING at $PKI_PATH/keys"
    find /var/lib/sbctl /usr/share/secureboot "$PKI_PATH" \
      -maxdepth 4 -name '*.key' 2>/dev/null | sed 's/^/           stray: /' || true
  fi

  echo
  echo "LUKS keyslots on $LUKS_DEV:"
  cryptsetup luksDump "$LUKS_DEV" 2>/dev/null | grep -iE "tokens|tpm2|keyslot|systemd-tpm2" || true
}

case "${1-}" in
keys) cmd_keys ;;
tpm) cmd_tpm ;;
status) cmd_status ;;
*)
  usage
  exit 1
  ;;
esac
