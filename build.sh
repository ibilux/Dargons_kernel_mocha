#!/bin/bash
R=$(pwd)
sudo find tc -type f -exec chmod a+rwx {} \;
export ARCH=arm
export CROSS_COMPILE=$R/tc/bin/arm-linux-gnueabihf- 
