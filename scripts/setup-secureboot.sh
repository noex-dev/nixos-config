#!/usr/bin/env bash
set -euo pipefail

LUKS_DEV="/dev/disk/by-partlabel/disk-main-luks"
PERSIST_PATH="/persist/etc/secureboot"
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
          Afterwards: reboot, ENABLE Secure Boot in the BIOS, boot (enter the
          LUKS passphrase manually once), then run 'tpm'.

  tpm     Phase 2: (re-)enroll the TPM2 keyslot for LUKS auto-unlock (PCRs $PCRS).
          Run this ONLY after Secure Boot is confirmed active, otherwise PCR 7
          changes on the next boot and auto-unlock breaks.

  status  Show current Secure Boot + TPM state.
EOF
}

cmd_keys() {
    if ! sbctl status | grep -q "Setup Mode"; then
        echo "Error: System is not in Setup Mode. Reset Secure Boot keys in the BIOS."
        exit 1
    fi

    mkdir -p "$PERSIST_PATH"
    if [ ! -f "$PERSIST_PATH/keys/PK/PK.key" ]; then
        echo "No existing keys found -> creating new ones."
        sbctl create-keys --export "$PERSIST_PATH" --disable-landlock
    else
        echo "Reusing existing keys from $PERSIST_PATH."
    fi

    mkdir -p /etc/secureboot
    mount --bind "$PERSIST_PATH" /etc/secureboot
    trap 'umount /etc/secureboot' EXIT

    sbctl enroll-keys --microsoft --disable-landlock

    echo
    echo "Verifying signatures of installed EFI binaries..."
    sbctl verify || true

    echo
    echo "== Phase 1 done. =="
    echo "Next steps:"
    echo "  1. Reboot and ENABLE Secure Boot in the BIOS."
    echo "  2. Boot (enter the LUKS passphrase manually this one time)."
    echo "  3. Verify: bootctl status  ->  'Secure Boot: enabled'"
    echo "  4. Run: sudo nix run .#setup-secureboot -- tpm"
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
    sbctl status || true
    echo
    bootctl status 2>/dev/null | grep -i "secure boot" || true
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
