#!/bin/bash
echo "Cloning dependencies"
git clone --depth=1  https://github.com/phoenix-1708/android_kernel_xiaomi_sweet.git -b arrow-11.0
cd android_kernel_xiaomi_sweet
git clone --depth=1 https://github.com/llvm/llvm-project clang
git clone https://github.com/phoenix-1708/Anykernel3-Tissot.git --depth=1 AnyKernel
git clone https://github.com/fabianonline/telegram.sh.git -b master
KERNEL_DIR=$(pwd)
REPACK_DIR="${KERNEL_DIR}/AnyKernel"
IMAGE="${KERNEL_DIR}/out/arch/arm64/boot/Image.gz"
DTB_T="${KERNEL_DIR}/out/arch/arm64/boot/dts/qcom/msm8953-qrd-sku3-tissot-treble.dtb"
DTB="${KERNEL_DIR}/out/arch/arm64/boot/dts/qcom/msm8953-qrd-sku3-tissot-nontreble.dtb"
SEND_DIR="${KERNEL_DIR}/telegram.sh"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
export PATH="$(pwd)/clang/bin:$PATH"
export ARCH=arm64
export KBUILD_BUILD_USER=phoenix-1708
export KBUILD_BUILD_HOST=circleci
# Compile plox
function compile() {
    make -j$(nproc --all) O=out ARCH=arm64 sweet_user_defconfig
    make -j$(nproc --all) O=out \
                          ARCH=arm64 \
                          CC=clang \
                          CROSS_COMPILE=aarch64-linux-gnu- \
                          CROSS_COMPILE_ARM32=arm-linux-gnueabi- \

    cd $REPACK_DIR
    mkdir kernel
    mkdir dtb-treble
    mkdir dtb-nontreble

    if ! [ -a "$IMAGE" ]; then
        exit 1
        echo "There are some issues with image"
    fi
    cp $IMAGE $REPACK_DIR/kernel/

    if ! [ -a "$DTB" ]; then
        exit 1
        echo "There are some issues dtb "
    fi
    cp $DTB $REPACK_DIR/dtb-nontreble/

    if ! [ -a "$DTB_T" ]; then
        exit 1
        echo "There are some issues dtb treble"
    fi
    cp $DTB_T $REPACK_DIR/dtb-treble/
}
# Zipping
function zipping() {
    cd $REPACK_DIR || exit 1
    zip -r9 PhoenixKernel_NonOC.zip *
    cd $SEND_DIR   || exit 1
    echo "Changing Dir to Send FIle"
    ./telegram -t 1858827137:AAFZVaKOjAhjVyCXfiGgL-SK6dp7_lILZIE -c -1001521910426 -f $REPACK_DIR/PhoenixKernel_NonOC.zip "Zip Sent through CircleCI"
   #curl --upload-file ./PhoenixKernel_NonOC.zip https://transfer.sh/PhoenixKernel_NonOC.zip
}
compile
zipping
echo "Finished"
