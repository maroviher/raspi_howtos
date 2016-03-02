usage ()
{
  echo 'MYCROSS_COMPILE=arm-cortex_a7-linux-gnueabihf- MOUNTED_EXT4_PART_ON_SDCARD=/media/ahmed/1234 MOUNTED_FAT_PART_ON_SDCARD=/media/ahmed/5678 sh compile_rpi2_kernel.sh'
}
ac_fn_c_try_compile ()
{
	cat - <<_ACEOF | ${MYCROSS_COMPILE}gcc -x c - -o /dev/null > /dev/null
int main ()
{
;
return 0;
}
_ACEOF
	[ $? -eq 0 ] ||  { echo "Toolchain no work, exiting..." ; usage ; exit 1; }
}

[ -z "$MOUNTED_FAT_PART_ON_SDCARD" ] && { echo 'error, MOUNTED_FAT_PART_ON_SDCARD is empty' ; usage ; exit 1; }
[ -z "$MOUNTED_EXT4_PART_ON_SDCARD" ] && { echo 'error, MOUNTED_EXT4_PART_ON_SDCARD is empty' ; usage ; exit 1; }
[ -z "$MYCROSS_COMPILE" ] && { echo 'error, MYCROSS_COMPILE is empty' ; usage ; exit 1; }
ac_fn_c_try_compile

[ -f '.config' ] || { echo "No kernel config, exiting..." ; exit 1; }
make ARCH=arm CROSS_COMPILE=$MYCROSS_COMPILE -j4 menuconfig || { echo "menuconfig error, exiting..." ; exit 1; }

make ARCH=arm CROSS_COMPILE=$MYCROSS_COMPILE -j4 || { echo "compilation error" ; exit 1; }
#here is compiled kernel: '/home/ahmed/rpi2kernel/linux/arch/arm/boot/zImage'
make ARCH=arm CROSS_COMPILE=$MYCROSS_COMPILE -j4 modules || { echo "modules compilation error" ; exit 1; }
rm -rf /tmp/modules_rpi2_gzip
mkdir /tmp/modules_rpi2_gzip || { echo "mkdir error for /tmp/modules_rpi2_gzip" ; exit 1; }
make ARCH=arm CROSS_COMPILE=$MYCROSS_COMPILE -j4 INSTALL_MOD_PATH=/tmp/modules_rpi2_gzip  INSTALL_MOD_STRIP=1 modules_install || { echo "modules_install error" ; exit 1; }
find /tmp/modules_rpi2_gzip/ -name *.ko -exec gzip {} \;
#copy gzipped KOs for new kernel
sudo cp -r /tmp/modules_rpi2_gzip/lib/* $MOUNTED_EXT4_PART_ON_SDCARD/lib || { echo "modules copying error to SD-Card" ; exit 1; }


rm $MOUNTED_FAT_PART_ON_SDCARD/*.dtb
cp arch/arm/boot/dts/*.dtb $MOUNTED_FAT_PART_ON_SDCARD/ || { echo "DTB copying error to SD-Card" ; exit 1; }
mkdir $MOUNTED_FAT_PART_ON_SDCARD/overlays
rm $MOUNTED_FAT_PART_ON_SDCARD/overlays/*.dtb*
cp arch/arm/boot/dts/overlays/*.dtb* $MOUNTED_FAT_PART_ON_SDCARD/overlays/ || { echo "Overlays DTB copying error to SD-Card" ; exit 1; }
#rm $MOUNTED_FAT_PART_ON_SDCARD/overlays/README
#cp arch/arm/boot/dts/overlays/README $MOUNTED_FAT_PART_ON_SDCARD/overlays/
mv $MOUNTED_FAT_PART_ON_SDCARD/kernel7.img $MOUNTED_FAT_PART_ON_SDCARD/kernel7.img_previous
scripts/mkknlimg arch/arm/boot/zImage $MOUNTED_FAT_PART_ON_SDCARD/kernel7.img || { echo "Error copying kernel file to SD-Card" ; exit 1; }
