
#!/bin/bash

#设置编译中临时文件目录，不然会报错 unable to create temporary file

export TMPDIR=D:/ffmpeg3.3.9/ffmpeg-3.3.9/ffmpegtemp

# NDK的路径，根据实际安装位置设置

NDK=D:/ndk15/android-ndk-r15c

# 编译针对的平台，这里选择最低支持android-14, arm架构，生成的so库是放在libs/armeabi文件夹下的，若针对x86架构，要选择arch-x86

PLATFORM=$NDK/platforms/android-14/arch-arm

# 工具链的路径，arm-linux-androideabi-4.9与上面设置的PLATFORM对应，4.9为工具的版本号

TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/windows-x86_64

 

function build_one

{

 

./configure \

    --prefix=$PREFIX \

    --target-os=linux \

    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \

    --arch=arm \

    --sysroot=$PLATFORM \

    --extra-cflags="-I$PLATFORM/usr/include" \

    --cc=$TOOLCHAIN/bin/arm-linux-androideabi-gcc \

    --nm=$TOOLCHAIN/bin/arm-linux-androideabi-nm \

    --disable-shared \

    --enable-runtime-cpudetect \

    --enable-gpl \

    --enable-small \

    --enable-cross-compile \

    --disable-debug \

    --enable-static \

    --disable-doc \

    --disable-asm \

    --disable-ffmpeg \

    --disable-ffplay \

    --disable-ffprobe \

    --disable-ffserver \

    --disable-postproc \

    --disable-avdevice \

    --disable-symver \

    --disable-stripping \

 

$ADDITIONAL_CONFIGURE_FLAG

sed -i '' 's/HAVE_LRINT 0/HAVE_LRINT 1/g' config.h

sed -i '' 's/HAVE_LRINTF 0/HAVE_LRINTF 1/g' config.h

sed -i '' 's/HAVE_ROUND 0/HAVE_ROUND 1/g' config.h

sed -i '' 's/HAVE_ROUNDF 0/HAVE_ROUNDF 1/g' config.h

sed -i '' 's/HAVE_TRUNC 0/HAVE_TRUNC 1/g' config.h

sed -i '' 's/HAVE_TRUNCF 0/HAVE_TRUNCF 1/g' config.h

sed -i '' 's/HAVE_CBRT 0/HAVE_CBRT 1/g' config.h

sed -i '' 's/HAVE_RINT 0/HAVE_RINT 1/g' config.h

 

make clean

make -j4

make install

 

$TOOLCHAIN/bin/arm-linux-androideabi-ld \

-rpath-link=$PLATFORM/usr/lib \

-L$PLATFORM/usr/lib \

-L$PREFIX/lib \

-soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \

$PREFIX/libffmpeg.so \

    libavcodec/libavcodec.a \

    libavfilter/libavfilter.a \

    libswresample/libswresample.a \

    libavformat/libavformat.a \

    libavutil/libavutil.a \

    libswscale/libswscale.a \

    -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \

    $TOOLCHAIN/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a \

	

}

 

# arm v7vfp

CPU=armv7-a

OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "

PREFIX=./android/$CPU-vfp

ADDITIONAL_CONFIGURE_FLAG=

build_one

 

# CPU=armv

# PREFIX=$(pwd)/android/$CPU

# ADDI_CFLAGS="-marm"

# build_one

 

#arm v6

#CPU=armv6

#OPTIMIZE_CFLAGS="-marm -march=$CPU"

#PREFIX=./android/$CPU 

#ADDITIONAL_CONFIGURE_FLAG=

#build_one

 

#arm v7vfpv3

# CPU=armv7-a

# OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfpv3-d16 -marm -march=$CPU "

# PREFIX=./android/$CPU

# ADDITIONAL_CONFIGURE_FLAG=

# build_one

 

#arm v7n

#CPU=armv7-a

#OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=neon -marm -march=$CPU -mtune=cortex-a8"

#PREFIX=./android/$CPU 

#ADDITIONAL_CONFIGURE_FLAG=--enable-neon

#build_one

 

#arm v6+vfp

#CPU=armv6

#OPTIMIZE_CFLAGS="-DCMP_HAVE_VFP -mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU"

#PREFIX=./android/${CPU}_vfp 

#ADDITIONAL_CONFIGURE_FLAG=

# build_one        
