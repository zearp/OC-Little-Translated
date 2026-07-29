#!/bin/sh
set -e
cd "$(dirname "$0")"
asr imagescan --source InstallMacOSX_10.10_Yosemite.dmg
did_find_volume="false"
while [ "$did_find_volume" = "false" ]
do
printf "Please enter the volume name of your USB flash drive: "
read -r target_volname
if [ -n "$target_volname" ] && df -l | grep -q "/Volumes/$target_volname$"
then
did_find_volume="true"
elif [ -n "$target_volname" ]
then
echo
echo "Could not find a volume named $target_volname. Found these volumes:"
df -l | awk -F'/Volumes/' '{print $2}' | grep -v '^$'
echo
fi
done
printf "WARNING: All data on the disk containing $target_volname will be erased. Continue? (yes/no) "
read -r confirmation
if [ "$confirmation" != "y" ] && [ "$confirmation" != "yes" ]
then
echo "Exiting. No changes have been made."
exit 1
fi
disk_identifier=$(diskutil info "/Volumes/$target_volname" | grep "Part of Whole:" | awk '{print $NF}')
if [ -z "$disk_identifier" ]
then
echo "Error: Could not determine disk identifier for $target_volname" 1>&2
exit 1
fi
sudo diskutil partitionDisk "$disk_identifier" GPT jhfs+ "$target_volname" 100%
sudo asr restore --source InstallMacOSX_10.10_Yosemite.dmg --noprompt --target "/Volumes/$target_volname" --erase
