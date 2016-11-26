#!/bin/bash

#
# 2016-11-17
# Author: Mizuki Urushida
#

# https://trac.ffmpeg.org/wiki/CompilationGuide/Centos

# ${INSTALL_DIR}
# `--ffmpeg
#    |--source
#    `--build
#       `--bin

# TODO: update library

usage_exit() {
	echo "Usage: $0 [-v] [DESTINATION]" 1>&2
	exit 1
}

dependency_check() {
	DEPENDENCY=(autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel)

	set packages
	for pkg in ${DEPENDENCY[@]}; do
		echo "---> Check package ${pkg}"

		rpm -q ${pkg}
		if [[ $? -ne 0 ]]; then
			if [[ -z "${packages}" ]]; then
				packages="${pkg}"
			else
				packages="${packages} ${pkg}"
			fi
		fi
	done

	if [[ ! -z "${packages}" ]]; then
		echo "------------------------------"
		echo "| Dependency is not clear... |"
		echo "------------------------------"
		echo "You have to execute the command below."
		echo "yum install ${packages}"
		exit 1
	else
		echo "------------------------"
		echo "| Dependency is clear! |"
		echo "------------------------"
	fi
}

install_yasm() {
	echo "---> Yasm Setup"

	cd "${INSTALL_DIR}/source"

	echo "---> Cloning yasm.git..."
	if [[ -z ${FLAG_V} ]]; then
		git clone --depth 1 git://github.com/yasm/yasm.git > /dev/null 2>&1
	else 
		git clone --depth 1 git://github.com/yasm/yasm.git
	fi

	cd yasm

	echo "---> Updating configuration file..."
	if [[ -z ${FLAG_V} ]]; then
		autoreconf -fiv > /dev/null 2>&1
	else 
		autoreconf -fiv
	fi

	echo "---> Generating Makefile..."
	if [[ -z ${FLAG_V} ]]; then
		./configure --prefix="${INSTALL_DIR}/build" --bindir="${INSTALL_DIR}/build/bin" > /dev/null 2>&1
	else 
		./configure --prefix="${INSTALL_DIR}/build" --bindir="${INSTALL_DIR}/build/bin"
	fi

	echo "---> Compiling..."
	if [[ -z ${FLAG_V} ]]; then
		make > /dev/null 2>&1
	else 
		make
	fi

	echo "---> Installing..."
	if [[ -z ${FLAG_V} ]]; then
		make install > /dev/null 2>&1
	else 
		make install
	fi

	echo "---> Finished installing Yasm!"
}

install_libx264() {
	echo "---> H.264 Video Encoder Setup"

	cd "${INSTALL_DIR}/source"

	echo "---> Cloning libx264..."
	if [[ -z ${FLAG_V} ]]; then
		git clone --depth 1 git://git.videolan.org/x264 > /dev/null 2>&1
	else 
		git clone --depth 1 git://git.videolan.org/x264
	fi

	cd x264

	echo "---> Generating Makefile..."
	if [[ -z ${FLAG_V} ]]; then
		PKG_CONFIG_PATH="${INSTALL_DIR}/build/lib/pkgconfig" ./configure --prefix="${INSTALL_DIR}/build" --bindir="${INSTALL_DIR}/build/bin" --enable-static > /dev/null 2>&1
	else 
		PKG_CONFIG_PATH="${INSTALL_DIR}/build/lib/pkgconfig" ./configure --prefix="${INSTALL_DIR}/build" --bindir="${INSTALL_DIR}/build/bin" --enable-static
	fi

	echo "---> Compiling..."
	if [[ -z ${FLAG_V} ]]; then
		make > /dev/null 2>&1
	else 
		make
	fi

	echo "---> Installing..."
	if [[ -z ${FLAG_V} ]]; then
		make install > /dev/null 2>&1
	else 
		make install
	fi

	echo "---> Finished installing H.264 Video Encoder!"
}

install_libx265() {
	echo "---> H.265/HEVC Video Encoder Setup"

	cd "${INSTALL_DIR}/source"

	echo "---> Cloning libx265..."
	if [[ -z ${FLAG_V} ]]; then
		hg clone https://bitbucket.org/multicoreware/x265 > /dev/null 2>&1
	else 
		hg clone https://bitbucket.org/multicoreware/x265
	fi

	cd x265/build/linux

	echo "---> Generating Makefile..."
	if [[ -z ${FLAG_V} ]]; then
		cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/build" -DENABLE_SHARED:bool=off ${INSTALL_DIR}/source/x265/source > /dev/null 2>&1
	else 
		cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/build" -DENABLE_SHARED:bool=off ${INSTALL_DIR}/source/x265/source
	fi

	echo "---> Compiling..."
	if [[ -z ${FLAG_V} ]]; then
		make > /dev/null 2>&1
	else 
		make
	fi

	echo "---> Installing..."
	if [[ -z ${FLAG_V} ]]; then
		make install > /dev/null 2>&1
	else 
		make install
	fi

	echo "---> Finished installing H.265/HEVC Video Encoder!"
}

install_libfdk_aac() {
	echo "---> AAC Audio Encoder Setup"

	cd "${INSTALL_DIR}/source"

	echo "---> Cloning libfdk_aac..."
	if [[ -z ${FLAG_V} ]]; then
		git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac > /dev/null 2>&1
	else 
		git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
	fi

	cd fdk-aac

	echo "---> Updating configuration file..."
	if [[ -z ${FLAG_V} ]]; then
		autoreconf -fiv > /dev/null 2>&1
	else 
		autoreconf -fiv
	fi

	echo "---> Generating Makefile..."
	if [[ -z ${FLAG_V} ]]; then
		./configure --prefix="${INSTALL_DIR}/build" --disable-shared > /dev/null 2>&1
	else 
		./configure --prefix="${INSTALL_DIR}/build" --disable-shared
	fi

	echo "---> Compiling..."
	if [[ -z ${FLAG_V} ]]; then
		make > /dev/null 2>&1
	else 
		make
	fi

	echo "---> Installing..."
	if [[ -z ${FLAG_V} ]]; then
		make install > /dev/null 2>&1
	else 
		make install
	fi

	echo "---> Finished setup AAC Audio Encoder!"
}

install_libmp3lame() {
	echo "---> MP3 Audio Encoder Setup"

	cd "${INSTALL_DIR}/source"

	echo "---> Cloning libmp3lame..."
	if [[ -z ${FLAG_V} ]]; then
		curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz > /dev/null 2>&1
		tar xzvf lame-3.99.5.tar.gz > /dev/null 2>&1
	else 
		curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
		tar xzvf lame-3.99.5.tar.gz
	fi

	cd lame-3.99.5

	echo "---> Generating Makefile..."
	if [[ -z ${FLAG_V} ]]; then
		./configure --prefix="${INSTALL_DIR}/build" --bindir="${INSTALL_DIR}/build/bin" --disable-shared --enable-nasm > /dev/null 2>&1
	else 
		./configure --prefix="${INSTALL_DIR}/build" --bindir="${INSTALL_DIR}/build/bin" --disable-shared --enable-nasm
	fi

	echo "---> Compiling..."
	if [[ -z ${FLAG_V} ]]; then
		make > /dev/null 2>&1
	else 
		make
	fi

	echo "---> Installing..."
	if [[ -z ${FLAG_V} ]]; then
		make install > /dev/null 2>&1
	else 
		make install
	fi

	echo "---> Finished setup MP3 Audio Encoder!"
}

install_libopus() {
	echo "---> Opus Audio Decoder and Encoder Setup"

	cd "${INSTALL_DIR}/source"

	echo "---> Cloning libopus..."
	if [[ -z ${FLAG_V} ]]; then
		git clone http://git.opus-codec.org/opus.git > /dev/null 2>&1
	else 
		git clone http://git.opus-codec.org/opus.git
	fi

	cd opus

	echo "---> Updating configuration file..."
	if [[ -z ${FLAG_V} ]]; then
		autoreconf -fiv > /dev/null 2>&1
	else 
		autoreconf -fiv
	fi

	echo "---> Generating Makefile..."
	if [[ -z ${FLAG_V} ]]; then
		PKG_CONFIG_PATH="${INSTALL_DIR}/build/lib/pkgconfig" ./configure --prefix="${INSTALL_DIR}/build" --disable-shared > /dev/null 2>&1
	else 
		PKG_CONFIG_PATH="${INSTALL_DIR}/build/lib/pkgconfig" ./configure --prefix="${INSTALL_DIR}/build" --disable-shared
	fi

	echo "---> Compiling..."
	if [[ -z ${FLAG_V} ]]; then
		make > /dev/null 2>&1
	else 
		make
	fi

	echo "---> Installing..."
	if [[ -z ${FLAG_V} ]]; then
		make install > /dev/null 2>&1
	else 
		make install
	fi

	echo "---> Finished setup Opus Audio Decoder and Encoder!"
}

install_libogg() {
	echo "---> Ogg Bitstream Library Setup"

	cd "${INSTALL_DIR}/source"

	echo "---> Cloning libogg..."
	if [[ -z ${FLAG_V} ]]; then
		curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz > /dev/null 2>&1
		tar xzvf libogg-1.3.2.tar.gz > /dev/null 2>&1
	else 
		curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
		tar xzvf libogg-1.3.2.tar.gz
	fi

	cd libogg-1.3.2

	echo "---> Generating Makefile..."
	if [[ -z ${FLAG_V} ]]; then
		./configure --prefix="${INSTALL_DIR}/build" --disable-shared > /dev/null 2>&1
	else 
		./configure --prefix="${INSTALL_DIR}/build" --disable-shared
	fi

	echo "---> Compiling..."
	if [[ -z ${FLAG_V} ]]; then
		make > /dev/null 2>&1
	else 
		make
	fi

	echo "---> Installing..."
	if [[ -z ${FLAG_V} ]]; then
		make install > /dev/null 2>&1
	else 
		make install
	fi

	echo "---> Finished setup Ogg Bitstream Library!"
}

install_libvorbis() {
	echo "---> Vorbis Audio Encoder Setup"

	cd "${INSTALL_DIR}/source"

	echo "---> Cloning libvorbis..."
	if [[ -z ${FLAG_V} ]]; then
		curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz > /dev/null 2>&1
		tar xzvf libvorbis-1.3.4.tar.gz > /dev/null 2>&1
	else 
		curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
		tar xzvf libvorbis-1.3.4.tar.gz
	fi

	cd libvorbis-1.3.4

	echo "---> Generating Makefile..."
	if [[ -z ${FLAG_V} ]]; then
		./configure --prefix="${INSTALL_DIR}/build" --with-ogg="${INSTALL_DIR}/build" --disable-shared > /dev/null 2>&1
	else 
		./configure --prefix="${INSTALL_DIR}/build" --with-ogg="${INSTALL_DIR}/build" --disable-shared
	fi

	echo "---> Compiling..."
	if [[ -z ${FLAG_V} ]]; then
		make > /dev/null 2>&1
	else 
		make
	fi

	echo "---> Installing..."
	if [[ -z ${FLAG_V} ]]; then
		make install > /dev/null 2>&1
	else 
		make install
	fi

	echo "---> Finished setup Vorbis Audio Encoder!"
}

install_libvpx() {
	echo "---> VP8/VP9 Video Encoder Setup"

	cd "${INSTALL_DIR}/source"

	echo "---> Cloning libvpx..."
	if [[ -z ${FLAG_V} ]]; then
		git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git > /dev/null 2>&1
	else 
		git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
	fi

	cd libvpx

	echo "---> Generating Makefile..."
	if [[ -z ${FLAG_V} ]]; then
		./configure --prefix="${INSTALL_DIR}/build" --disable-examples > /dev/null 2>&1
	else 
		./configure --prefix="${INSTALL_DIR}/build" --disable-examples
	fi

	echo "---> Compiling..."
	if [[ -z ${FLAG_V} ]]; then
		make > /dev/null 2>&1
	else 
		make
	fi

	echo "---> Installing..."
	if [[ -z ${FLAG_V} ]]; then
		make install > /dev/null 2>&1
	else 
		make install
	fi

	echo "---> Finished setup VP8/VP9 Video Encoder!"
}

install_ffmpeg() {
	echo "---> FFmpeg Setup"

	cd "${INSTALL_DIR}/source"

	echo "---> Cloning ffmpeg..."
	if [[ -z ${FLAG_V} ]]; then
		curl -O http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 > /dev/null 2>&1
		tar xjvf ffmpeg-snapshot.tar.bz2 > /dev/null 2>&1
	else 
		curl -O http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
		tar xjvf ffmpeg-snapshot.tar.bz2
	fi

	cd ffmpeg

	echo "---> Generating Makefile..."
	if [[ -z ${FLAG_V} ]]; then
		PKG_CONFIG_PATH="${INSTALL_DIR}/build/lib/pkgconfig" ./configure --prefix="${INSTALL_DIR}/build" --extra-cflags="-I${INSTALL_DIR}/build/include" --extra-ldflags="-L${INSTALL_DIR}/build/lib -ldl" --bindir="${INSTALL_DIR}/build/bin" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 > /dev/null 2>&1
	else 
		PKG_CONFIG_PATH="${INSTALL_DIR}/build/lib/pkgconfig" ./configure --prefix="${INSTALL_DIR}/build" --extra-cflags="-I${INSTALL_DIR}/build/include" --extra-ldflags="-L${INSTALL_DIR}/build/lib -ldl" --bindir="${INSTALL_DIR}/build/bin" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265
	fi

	echo "---> Compiling..."
	if [[ -z ${FLAG_V} ]]; then
		make > /dev/null 2>&1
	else 
		make
	fi

	echo "---> Installing..."
	if [[ -z ${FLAG_V} ]]; then
		make install > /dev/null 2>&1
	else 
		make install
	fi

	echo "---> Finished setup FFmpeg!"
}

dependency_check

while getopts "v" OPT
do
	case $OPT in
		v)	# verbose
			FLAG_V=0
			;;
		\?)	usage_exit
			;;
	esac
done
shift $((OPTIND - 1))

if [[ $# -gt 1 ]]; then
	echo "Too many arguments"
	exit 1
else
	APP="ffmpeg"
	if [[ -z $1 ]]; then
		INSTALL_DIR="${PWD}/${APP}"
	else
		INSTALL_DIR="$(readlink -f $1)/${APP}"
	fi
fi

echo -n "Can I install in ${INSTALL_DIR}? [y/N] "
read confirm
# String comparing have to use "=" "!=", not "-eq" "-ne".
if [[ "${confirm}" != "y" ]]; then
	echo "Installation is interrupted"
	exit 1
fi

mkdir "${INSTALL_DIR}"
if [[ $? -ne 0 ]]; then
	echo "Cannot make installation directory"
	exit 1
fi

mkdir "${INSTALL_DIR}/source"
mkdir "${INSTALL_DIR}/build"
mkdir "${INSTALL_DIR}/build/bin"

# important
export PATH="$PATH:${INSTALL_DIR}/build/bin"

install_yasm
install_libx264
install_libx265
install_libfdk_aac
install_libmp3lame
install_libopus
install_libogg
install_libvorbis
install_libvpx
install_ffmpeg

echo "Installation complete!"
