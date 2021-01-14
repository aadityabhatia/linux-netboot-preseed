#!/bin/bash
set -e

test $UID -ne 0 && echo Must be root. && exit 2
test -z "$2" && printf "\nSyntax: $0 DRIVE EFI_FILE\n\n" && exit 2

DRIVE="$1"
EFI_FILE="$2"

# ensure DRIVE is block device
test ! -b $DRIVE && echo "Drive not found: $DRIVE" && exit 3

# ensure EFI_FILE is a DOS executable file
test ! -f $EFI_FILE && echo "EFI file not found: $EFI_FILE" && exit 4
test "$(file --brief --mime-type $EFI_FILE)" != "application/x-dosexec" && echo "Not an EFI executable: $EFI_FILE" && exit 5

printf "Target Drive: \t%s\nEFI file: \t%s\n\n" $DRIVE $EFI_FILE

# display disk information
lsblk -o NAME,SIZE,TYPE,VENDOR,MODEL,REV,SERIAL,STATE $DRIVE

# display actions
printf "\nWiping $DRIVE...\n\n"

# prompt for user confirmation
read -p "Proceed? [y/N] " -n 1 -r proceed
echo
test "y$proceed" != "yy" && test "y$proceed" != "yY" && echo "Aborted." && exit
printf "\n"

# unmount all partitions on the drive
mountpoints=$(grep $DRIVE /proc/mounts | awk '{print $1}')
test -n "$mountpoints" && umount -v $mountpoints
printf "\n"

# calculate partition size
partitionSize=$(( $(du -m $EFI_FILE | cut -f 1) + 1 ))

# wipe partition table and create a new GPT structure
sgdisk --zap-all --new 1:1M:+${partitionSize}M --typecode=0:EF00 $DRIVE
printf "Create new GPT structure on $DRIVE \n\n"

# update kernel partition table
partprobe -s $DRIVE && sleep 1
printf "OS partition table updated \n\n"

#
mkfs.fat -n IPXE ${DRIVE}1
printf "FAT32 filesystem created: ${DRIVE}1 \n\n"

TMPDIR=$(mktemp -d)
mount -v ${DRIVE}1 $TMPDIR
mkdir -vp $TMPDIR/EFI/BOOT
cp -v $EFI_FILE $TMPDIR/EFI/BOOT/BOOTX64.EFI
umount -v ${DRIVE}1
rmdir -v $TMPDIR

printf "\nEFI bootable drive created. Success!\n\n"
