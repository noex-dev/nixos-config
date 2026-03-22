#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root." 
   exit 1
fi

if ! sbctl status | grep -q "Setup Mode"; then
    echo "Error: System is not in Setup Mode. Reset Secure Boot keys in BIOS."
    exit 1
fi

PERSIST_PATH="/persist/etc/secureboot"
mkdir -p "$PERSIST_PATH"

if [ ! -f "$PERSIST_PATH/keys/PK/PK.key" ]; then
    TEMP_KEYS=$(mktemp -d)
    sbctl create-keys --export "$TEMP_KEYS" --disable-landlock
    cp -r "$TEMP_KEYS"/* "$PERSIST_PATH/"
    rm -rf "$TEMP_KEYS"
fi

mkdir -p /etc/secureboot
mount --bind "$PERSIST_PATH" /etc/secureboot

sbctl enroll-keys --microsoft --disable-landlock

systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7 /dev/disk/by-partlabel/disk-main-luks

umount /etc/secureboot

echo "Setup complete. Run 'nixos-rebuild switch' next."
