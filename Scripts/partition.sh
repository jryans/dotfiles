# See also
# https://nixos.org/manual/nixos/stable/
# https://grahamc.com/blog/erase-your-darlings/
# https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
# https://nixos.wiki/wiki/ZFS
# https://wiki.archlinux.org/title/ZFS
# https://openzfs.github.io/openzfs-docs/Performance%20and%20Tuning/Workload%20Tuning.html
# https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/

# Run memtest first

# Partitioning
# https://nixos.org/manual/nixos/stable/#sec-installation-manual-partitioning

# Create GPT partition table
parted /dev/XXX -- mklabel gpt

# Create EFI, root, and swap partitions
parted /dev/XXX -- mkpart ESP fat32 1MB 512MB
parted /dev/XXX -- set 1 esp on
parted /dev/XXX -- mkpart root zfs 512MB -4GB
parted /dev/XXX -- mkpart swap linux-swap -4GB 100%

# Check sector size for correct `ashift` value
# https://wiki.archlinux.org/title/ZFS#Advanced_Format_disks
blockdev --getpbsz /dev/XXX

# Create ZFS pool on root partition
# https://nixos.wiki/wiki/ZFS
# https://openzfs.github.io/openzfs-docs/man/v2.3/7/zfsprops.7.html
zpool create \
  -o ashift=12 \
  -O compression=zstd \
  -O encryption=on \
  -O keyformat=passphrase \
  -O keylocation=prompt \
  -O acltype=posix \
  -O xattr=sa \
  -O atime=off \
  -O mountpoint=none \
  pool \
  /dev/XXXp2

# Create and mount datasets
# https://nixos.wiki/wiki/ZFS
# https://grahamc.com/blog/erase-your-darlings/
# https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
zfs create -o mountpoint=legacy pool/cache/root
zfs create -o mountpoint=legacy pool/cache/nix
zfs create -o mountpoint=legacy pool/cache/log
zfs create -o mountpoint=legacy pool/safe/home
zfs create -o mountpoint=legacy pool/safe/persist

zfs snapshot pool/cache/root@empty

mkdir /mnt
mount -t zfs pool/cache/root /mnt
mkdir /mnt/nix
mount -t zfs pool/cache/nix /mnt/nix
mkdir -p /mnt/var/log
mount -t zfs pool/cache/log /mnt/var/log
mkdir /mnt/home
mount -t zfs pool/safe/home /mnt/home
mkdir /mnt/persist
mount -t zfs pool/safe/persist /mnt/persist

# Create and mount EFI partition
mkfs.fat -F 32 -n boot /dev/XXXp1
mkdir /mnt/boot
mount /dev/XXXp1 /mnt/boot

# Create and mount swap partition
mkswap -L swap /dev/XXXp3
swapon /dev/XXXp3

# Create NixOS configuration
nixos-generate-config --root /mnt
vim /mnt/etc/nixos/configuration.nix
# Modify according to https://nixos.wiki/wiki/ZFS

# Install
nixos-install
reboot

# Consider reducing `vm.swappiness`

# Consider ZFS scrub and trim processes
# https://nixos.wiki/wiki/ZFS#Tips
# https://wiki.archlinux.org/title/ZFS#Tuning

# Add model-specific settings from nixos-hardware

# Eventually, persist things and rollback root on each boot
