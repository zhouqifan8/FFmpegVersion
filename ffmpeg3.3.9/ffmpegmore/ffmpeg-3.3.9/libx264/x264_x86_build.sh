
NDK=D:/ndk15/android-ndk-r15c

PLATFORM=$NDK/platforms/android-14/arch-x86/
TOOLCHAIN=$NDK/toolchains/x86-4.9/prebuilt/windows-x86_64
PREFIX=./android/x86

function build_one
{
./configure \
--prefix=$PREFIX \
--disable-shared \
--enable-static \
--disable-asm \
--enable-pic \
--enable-strip \
--host=i686-linux \
--cross-prefix=$TOOLCHAIN/bin/i686-linux-android- \
--sysroot=$PLATFORM \
--extra-cflags="-Os -fpic" \
--extra-ldflags="" \

make clean
make
make install
}

build_one

