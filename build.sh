#!/bin/bash
R=$(pwd)
export ARCH=arm
DEFCONFIG=mocha_android_defconfig
CROSS_COMPILER=$R/tc/bin/arm-linux-gnueabihf- 
OUT_DIR=$R/out
BUILDING_DIR=$OUT_DIR/kernel_obj
MODULES_DIR=$OUT_DIR/modules
JOBS=8 # x Number of cores

mkdir -p $OUT_DIR $BUILDING_DIR $MODULES_DIR
FUNC_CLEANUP()
{
	echo -e "\n\e[95mCleaning up..."
	rm -rf $OUT_DIR $ANYKERNEL_DIR
	mkdir -p $OUT_DIR $BUILDING_DIR $MODULES_DIR
	echo -e "\e[34mAll clean!"
}

FUNC_COMPILE()
{
	echo -e "\n\e[95mStarting the build..."
	make -C $R O=$BUILDING_DIR $DEFCONFIG 
	make -j$JOBS -C $R O=$BUILDING_DIR ARCH=arm CROSS_COMPILE=$CROSS_COMPILER
	cp $OUT_DIR/kernel_obj/arch/arm/boot/zImage $OUT_DIR/zImage
	echo -e "\e[34mJob done!"

	echo -e "\n\e[95mCopying the Modules..."
	rm -rf $MODULES_DIR
	mkdir $MODULES_DIR
	find . -name "*.ko" -exec cp {} $MODULES_DIR \;
	echo -e "\e[34mDone!"
}

echo -e -n "\e[33mDo you want to clean build directory (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg

if echo "$answer" | grep -iq "^y" ;then
    FUNC_CLEANUP
    FUNC_COMPILE
else
    rm -r $OUT_DIR/zImage
    FUNC_COMPILE
    
fi
