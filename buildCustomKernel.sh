#!/bin/sh
# @Author: logic
# @Email: santoshvkushwaha@gmail.com
# @Date:   2015-11-19 19:46:04
# @Last Modified by:   logic
# @Last Modified time: 2015-11-19 21:17:55

# ~/Scripts/buildCustomKernel.sh
# Script for building a custom Kernel in Gentoo.
BUILD_DIR="/usr/src/linux"
CONFIG_FILE_TEMPLATE="/home/logic/Data/dotfiles/sl410-config"
GRUB_CONFIG="/boot/grub/grub.cfg"

function errorExit() {
	notify-send "buildCustomKernel" $1 --icon=dialog-information --expire-time=10000
	exit 1
}

function configFile() {
	notify-send "buildCustomKernel" "Copying config file..." --icon=dialog-information --expire-time=5000
    cp $CONFIG_FILE_TEMPLATE ${BUILD_DIR}/
    if [ -f $CONFIG_FILE_TEMPLATE ]; then
    	mv $CONFIG_FILE_TEMPLATE ${BUILD_DIR}/.config
    else
        errorExit "config file not found. Aborting!"
    fi
}

function changeConfig() {
	cd $BUILD_DIR
	make menuconfig
}

function arch64Compilation() {
	make modules_prepare
    make
    make modules_install
}

function mountBoot() {
	notify-send "buildCustomKernel" "Mounting boot partition..." --icon=dialog-information --expire-time=5000
    if grep -qs '/dev/sda3' /proc/mounts; then
        notify-send "buildCustomKernel" "already mounted." --icon=dialog-information --expire-time=10000
    else
        mount /boot
        notify-send "buildCustomKernel" "boot partition mounted." --icon=dialog-information --expire-time=10000
    fi
}
function ramdiskNFileInstallation() {
	notify-send "buildCustomKernel" "Installing boot files to boot..." --icon=dialog-information --expire-time=5000
    make install
    notify-send "buildCustomKernel" "Installing ramdisk to boot..." --icon=dialog-information --expire-time=5000
    genkernel --install initramfs
    notify-send "buildCustomKernel" "All files are installed to boot." --icon=dialog-information --expire-time=10000
}
function bootloaderUpdate() {
	notify-send "buildCustomKernel" "Updating Grub bootloader." --icon=dialog-information --expire-time=5000
    grub2-mkconfig -o $GRUB_CONFIG
    notify-send "buildCustomKernel" "Grub Updated." --icon=dialog-information --expire-time=10000
}

function cleanup() {
	umount /boot
	notify-send "buildCustomKernel" "boot unmounted" --icon=dialog-information --expire-time=10000
}

if [[ $USER != root ]]; then
	errorExit "This Script must be run with sudo privileges."
fi

configFile
if [[ "$?" == "0" ]]; then
	changeConfig
	arch64Compilation
	mountBoot
	ramdiskNFileInstallation
	bootloaderUpdate
	cleanup
else
	errorExit "Error occured probably in the function 'configFile'."
fi