#!/bin/bash

# Colors
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
cyan='\033[0;36m'
yellow='\033[0;33m'
blue='\033[0;34m'
default='\033[0m'

# mkdir -p /tmp/rom # Where to sync source
# cd /tmp/rom
git clone https://github.com/phoenix-1708/scripts.git && cd scripts && bash setup/android_build_env.sh && cd ..

mkdir phoenix
cd phoenix

echo "Cloning dependencies"
git clone --depth=1 https://github.com/ArrowOS-Devices/android_kernel_xiaomi_sweet.git -b arrow-11.0
# git clone --depth=1 https://github.com/crdroidandroid/android_kernel_xiaomi_sweet.git -b 11.0
cd android_kernel_xiaomi_sweet

# git clone --depth=1 https://github.com/xyz-prjkt/xRageTC-clang.git clang
# git clone --depth=1 https://github.com/Haseo97/Avalon-Clang-12.0.0.git clang
# git clone https://github.com/phoenix-1708/Anykernel3-Tissot.git  --depth=1 AnyKernel
git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86
# git clone --depth=1 https://github.com/kdrag0n/proton-clang.git clang
git clone https://github.com/stormbreaker-project/aarch64-linux-android-4.9.git
git clone https://github.com/stormbreaker-project/arm-linux-androideabi-4.9.git
git clone https://github.com/fabianonline/telegram.sh.git  -b master
KERNEL_DIR=/home/runner/work/sweet_kernel/phoenix/android_kernel_xiaomi_sweet
REPACK_DIR="${KERNEL_DIR}/AnyKernel"
IMAGE="${KERNEL_DIR}/out/arch/arm64/boot/Image.gz"
DTB_T="${KERNEL_DIR}/out/arch/arm64/boot/dts/qcom/msm8953-qrd-sku3-tissot-treble.dtb"
DTB="${KERNEL_DIR}/out/arch/arm64/boot/dts/qcom/msm8953-qrd-sku3-tissot-nontreble.dtb"
SEND_DIR="${KERNEL_DIR}/telegram.sh"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
export PATH="/home/runner/work/sweet_kernel/phoenix/android_kernel_xiaomi_sweet/linux-x86/clang-r416183c/bin:/home/runner/work/sweet_kernel/phoenix/android_kernel_xiaomi_sweet/aarch64-linux-android-4.9/bin:/home/runner/work/sweet_kernel/phoenix/android_kernel_xiaomi_sweet/arm-linux-androideabi-4.9/bin:$PATH"
export ARCH=arm64
export KBUILD_BUILD_USER=phoenix-1708
export KBUILD_BUILD_HOST=ubuntu
export TARGET_KERNEL_CLANG_COMPILE=true
echo -e "$green***********************************************"
echo  "          Compiling Phoenix Kernel              "
echo -e "***********************************************"
# Compile plox
make -j$(nproc --all) O=out ARCH=arm64 sweet_user_defconfig
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-android- \
                      CROSS_COMPILE_ARM32=arm-linux-androideabi- \
                          
