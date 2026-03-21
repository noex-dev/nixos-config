#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo ./install.sh <hostname>"
  exit 1
fi

if [ -z "${1-}" ]; then
  echo "Error: No hostname provided."
  echo "Usage: sudo ./install.sh <hostname>"
  exit 1
fi

HOST=$1

export NIX_CONFIG="experimental-features = nix-command flakes"

echo "Starting automated NixOS installation for host: $HOST"


nix shell nixpkgs#git-lfs -c git lfs install
nix shell nixpkgs#git-lfs -c git lfs pull

nix run github:nix-community/disko/latest -- --mode disko --flake ".#$HOST"

chmod 755 /mnt
umount /mnt/boot || true
chmod 755 /mnt/boot
mount -o dmask=0022,fmask=0022 /dev/disk/by-partlabel/disk-main-ESP /mnt/boot

mkdir -p /mnt/persist/etc/ssh
ssh-keygen -t ed25519 -N "" -C "root@$HOST" -f /mnt/persist/etc/ssh/ssh_host_ed25519_key

PUB_KEY=$(nix shell nixpkgs#ssh-to-age -c ssh-to-age < /mnt/persist/etc/ssh/ssh_host_ed25519_key.pub)

echo ""
echo "=================================================================="
echo "ACTION REQUIRED: UPDATE SOPS KEYS"
echo "=================================================================="
echo "The age public key for $HOST is:"
echo -e "\033[1;32m$PUB_KEY\033[0m"
echo ""
echo "Execute the following on your configured machine:"
echo "1. Add the key above to .sops.yaml under the $HOST entry"
echo "2. Run: sops updatekeys secrets/secrets.yaml"
echo "3. Run: git commit -am 'add sops key for $HOST' && git push"
echo "=================================================================="
read -p "Press ENTER once the changes have been pushed..."

git reset --hard HEAD
git pull --rebase origin main

nixos-install --flake ".#$HOST" --root /mnt --no-root-passwd

echo "Installation finished successfully. You may now reboot."
