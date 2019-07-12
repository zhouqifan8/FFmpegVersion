#!/bin/sh

MY_LIBS_NAME=ffmpeg-4.0
MY_DIR=ffmpeg-4.0

# cd ./${MY_DIR}

#编译的过程中产生的中间件的存放目录，为了区分编译目录，源码目录，install目录
MY_BUILD_DIR=binary


NDK_PATH=D:/AS/NDK/android-ndk-r15c
BUILD_PLATFORM=windows-x86_64
TOOLCHAIN_VERSION=4.9
ANDROID_VERSION=18

ANDROID_ARMV5_CFLAGS="-march=armv5te"
ANDROID_ARMV7_CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=neon"  #-mfloat-abi=hard -mfpu=vfpv3-d16 #-mfloat-abi=hard -mfpu=vfp
ANDROID_ARMV8_CFLAGS="-march=armv8-a"
ANDROID_X86_CFLAGS="-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"
ANDROID_X86_64_CFLAGS="-march=x86-64 -msse4.2 -mpopcnt -m64 -mtune=intel"


# params($1:arch,$2:arch_abi,$3:host,$4:cross_prefix,$5:cflags)
build_bin() {

	echo "-------------------star build $2-------------------------"

	ARCH=$1			# arm arm64 x86 x86_64
	ANDROID_ARCH_ABI=$2 	# armeabi armeabi-v7a x86 mips

	PREFIX=$(pwd)/dist/${MY_LIBS_NAME}/${ANDROID_ARCH_ABI}/

	HOST=$3
	SYSROOT=${NDK_PATH}/platforms/android-${ANDROID_VERSION}/arch-${ARCH}

	CFALGS=$5


	TOOLCHAIN=${NDK_PATH}/toolchains/${HOST}-${TOOLCHAIN_VERSION}/prebuilt/${BUILD_PLATFORM}
	CROSS_PREFIX=${TOOLCHAIN}/bin/$4-

	# build 中间件
    BUILD_DIR=./${MY_BUILD_DIR}/${ANDROID_ARCH_ABI}

	echo "pwd==$(pwd)"
	echo "ARCH==${ARCH}"
	echo "PREFIX==${PREFIX}"
	echo "HOST==${HOST}"
	echo "SYSROOT=${SYSROOT}"
	echo "CFALGS=$5"
	echo "CFALGS=${CFALGS}"
	echo "TOOLCHAIN==${TOOLCHAIN}"
	echo "CROSS_PREFIX=${CROSS_PREFIX}"

	#echo "-------------------------按任意键继续---------------------"
	#read -n 1
	#echo "-------------------------继续执行-------------------------"

	mkdir -p ${BUILD_DIR}   #创建当前arch_abi的编译目录,比如:binary/armeabi-v7a
    cd ${BUILD_DIR}         #此处 进了当前arch_abi的2级编译目录

	#--extra-ldflags="-L${SYSROOT}/usr/lib" \
	#--extra-ldflags="-fPIC" \
	#--extra-cxxflags="-D__thumb__ -fPIC -fexceptions -frtti" \
	#--enable-neon \
	sh ../../${MY_DIR}/configure \
		--prefix=${PREFIX} \
		--target-os=android \
		--arch=${ARCH} \
		--sysroot=$SYSROOT \
		--enable-cross-compile \
		--cross-prefix=${CROSS_PREFIX} \
		--extra-cflags="$CFALGS -Os -fPIC -DANDROID -Wfatal-errors -Wno-deprecated" \
		--extra-ldflags="-L${SYSROOT}/usr/lib" \
		--disable-static \
		--enable-shared \
		--disable-yasm \
        --disable-asm \
		--enable-pic \
		--disable-x86asm \
		--enable-jni \
		--enable-mediacodec \
		--disable-encoders \
		--enable-encoder=aac \
		--enable-encoder=mjpeg \
		--enable-encoder=png \
		--disable-decoders \
		--enable-decoder=aac \
		--enable-decoder=aac_latm \
		--enable-decoder=h264 \
		--enable-decoder=h264_mediacodec \
		--enable-hwaccel=h264_mediacodec \
		--enable-decoder=mpeg4 \
		--enable-decoder=mpeg4_mediacodec \
		--enable-decoder=mjpeg \
		--enable-decoder=png \
		--disable-demuxers \
		--enable-demuxer=image2 \
		--enable-demuxer=h264 \
		--enable-demuxer=aac \
		--disable-parsers \
		--enable-parser=aac \
		--enable-parser=ac3 \
		--enable-parser=h264 \
		--enable-gpl \
		--disable-doc \
		--disable-ffmpeg \
		--disable-ffplay \
		--disable-ffprobe \
		--disable-symver \
		--disable-debug \
		--enable-small


	make clean
	make
	make install

	#从当前arch_abi编译目录跳出，对应上面的cd ${BUILD_DIR},以便function多次执行
    	cd ../../

	echo "-------------------$2 build end-------------------------"
}


# build armeabi
#build_bin arm armeabi arm-linux-androideabi arm-linux-androideabi "$ANDROID_ARMV5_CFLAGS"

#build armeabi-v7a
#build_bin arm armeabi-v7a arm-linux-androideabi arm-linux-androideabi "$ANDROID_ARMV7_CFLAGS"

#build arm64-v8a
#build_bin arm64 arm64-v8a aarch64-linux-android aarch64-linux-android "$ANDROID_ARMV8_CFLAGS"

#build x86
build_bin x86 x86 x86 i686-linux-android "$ANDROID_X86_CFLAGS"

#build x86_64
#build_bin x86_64 x86_64 x86_64 x86_64-linux-android "$ANDROID_X86_64_CFLAGS"

