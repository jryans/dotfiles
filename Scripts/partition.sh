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
parted /dev/nvme0n1 -- mklabel gpt

# Create EFI, root, and swap partitions
parted /dev/nvme0n1 -- mkpart esp fat32 1MiB 512MiB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart root 512MiB -4GiB
parted /dev/nvme0n1 -- mkpart swap linux-swap -4GiB 100%

# Check sector size for correct `ashift` value
# https://wiki.archlinux.org/title/ZFS#Advanced_Format_disks
blockdev --getpbsz /dev/nvme0n1

# Create ZFS pool on root partition
# https://nixos.wiki/wiki/ZFS
# https://openzfs.github.io/openzfs-docs/man/v2.3/7/zfsprops.7.html
# Add `-o ashift=12` or similar based on results above
zpool create \
  -O compression=zstd \
  -O encryption=on \
  -O keyformat=passphrase \
  -O keylocation=prompt \
  -O acltype=posix \
  -O xattr=sa \
  -O atime=off \
  -O mountpoint=none \
  pool \
  /dev/nvme0n1p2

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
mkfs.fat -F 32 -n boot /dev/nvme0n1p1
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

# Create and mount swap partition
mkswap -L swap /dev/nvme0n1p3
swapon /dev/nvme0n1p3

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
