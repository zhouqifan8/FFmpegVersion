#!/bin/bash
#填写你具体的ndk解压目录（改为自己的目录）
export TMPDIR=D:/ffmpeg-3.2.1/ffmpegtemp
export NDK=D:/ndk15/android-ndk-r15c
#定义android最低版本，必须低于目标手机使用版本
export SYSROOT=$NDK/platforms/android-9/arch-arm/
export TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/windows-x86_64
export CPU=arm
#编译后的文件会放置在 当前路径下的android/arm／下
export PREFIX=$(pwd)/android/$CPU
export ADDI_CFLAGS="-marm"
#./configure 即为ffmpeg 根目录下的可执行文件configure
#你可以在ffmpeg根目录下使用./configure --hellp 查看 ./configure后可填入的参数。
./configure \
        --target-os=linux \
        --prefix=$PREFIX \
		--arch=arm \
        --disable-doc \
        --enable-shared \
        --disable-static \
        --disable-yasm \
        --disable-symver \
        --enable-gpl \
        --disable-ffmpeg \
        --disable-ffplay \
        --disable-ffprobe \
        --disable-ffserver \
        --disable-doc \
        --disable-symver \
        --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
        --enable-cross-compile \
        --sysroot=$SYSROOT \
        --extra-cflags="-Os -fpic $ADDI_CFLAGS" \
        --extra-ldflags="$ADDI_CFLAGS" \
        $ADDITIONAL_CONFIGURE_FLAG
make clean
make
make install
