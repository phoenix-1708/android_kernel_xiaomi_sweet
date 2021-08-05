#!/bin/bash

# Zipping
KERNEL_DIR=/home/runner/work/sweet_kernel/phoenix/android_kernel_xiaomi_sweet
IMAGE="${KERNEL_DIR}/out/arch/arm64/boot/Image.gz"
cd telegram.sh
./telegram -t 1858827137:AAFZVaKOjAhjVyCXfiGgL-SK6dp7_lILZIE -c -509071822 -f $IMAGE
echo "Zip Sent through GithubActions"
   #curl --upload-file ./PhoenixKernel_NonOC.zip https://transfer.sh/PhoenixKernel_NonOC.zip
echo -e "$cyan**************************************************"
echo  "                 Build Completed                    "
echo -e "***********************************************$default"
