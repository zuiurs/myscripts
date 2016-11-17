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
# TODO: verbose option (hide compile information)

dependency_check() {
	DEPENDENCY=(autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel)

	set packages
	for pkg in ${DEPENDENCY[@]}; do
		echo "---> Check package ${pkg}"

		rpm -q ${pkg}
		if [ $? -ne 0 ]; then
			if [ -z "${packages}" ]; then
				packages="${pkg}"
			else
				packages="${packages} ${pkg}"
			fi
		fi
	done

	if [ ! -z "${packages}" ]; then
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
	cd "${INSTALL_DIR}/source"
	git clone --depth 1 git://github.com/yasm/yasm.git
	cd yasm
	autoreconf -fiv
	./configure --prefix="${INSTALL_DIR}/build" --bindir="${INSTALL_DIR}/build/bin"
	make
	make install
}

install_libx264() {
	cd "${INSTALL_DIR}/source"
	git clone --depth 1 git://git.videolan.org/x264
	cd x264
	PKG_CONFIG_PATH="${INSTALL_DIR}/build/lib/pkgconfig" ./configure --prefix="${INSTALL_DIR}/build" --bindir="${INSTALL_DIR}/build/bin" --enable-static
	make
	make install
}

install_libx265() {
	cd "${INSTALL_DIR}/source"
	hg clone https://bitbucket.org/multicoreware/x265
	cd x265/build/linux
	cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/build" -DENABLE_SHARED:bool=off ${INSTALL_DIR}/source/x265/source
	make
	make install
}

install_libfdk_aac() {
	cd "${INSTALL_DIR}/source"
	git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
	cd fdk-aac
	autoreconf -fiv
	./configure --prefix="${INSTALL_DIR}/build" --disable-shared
	make
	make install
}

install_libmp3lame() {
	cd "${INSTALL_DIR}/source"
	curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
	tar xzvf lame-3.99.5.tar.gz
	cd lame-3.99.5
	./configure --prefix="${INSTALL_DIR}/build" --bindir="${INSTALL_DIR}/build/bin" --disable-shared --enable-nasm
	make
	make install
}

install_libopus() {
	cd "${INSTALL_DIR}/source"
	git clone http://git.opus-codec.org/opus.git
	cd opus
	autoreconf -fiv
	PKG_CONFIG_PATH="${INSTALL_DIR}/build/lib/pkgconfig" ./configure --prefix="${INSTALL_DIR}/build" --disable-shared
	make
	make install
}

install_libogg() {
	cd "${INSTALL_DIR}/source"
	curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
	tar xzvf libogg-1.3.2.tar.gz
	cd libogg-1.3.2
	./configure --prefix="${INSTALL_DIR}/build" --disable-shared
	make
	make install
}

install_libvorbis() {
	cd "${INSTALL_DIR}/source"
	curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
	tar xzvf libvorbis-1.3.4.tar.gz
	cd libvorbis-1.3.4
	./configure --prefix="${INSTALL_DIR}/build" --with-ogg="${INSTALL_DIR}/build" --disable-shared
	make
	make install
}

install_libvpx() {
	cd "${INSTALL_DIR}/source"
	git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
	cd libvpx
	./configure --prefix="${INSTALL_DIR}/build" --disable-examples
	make
	make install
}

install_ffmpeg() {
	cd "${INSTALL_DIR}/source"
	curl -O http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
	tar xjvf ffmpeg-snapshot.tar.bz2
	cd ffmpeg
	PKG_CONFIG_PATH="${INSTALL_DIR}/build/lib/pkgconfig" ./configure --prefix="${INSTALL_DIR}/build" --extra-cflags="-I${INSTALL_DIR}/build/include" --extra-ldflags="-L${INSTALL_DIR}/build/lib -ldl" --bindir="${INSTALL_DIR}/build/bin" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265
	make
	make install
}

if [ $# -gt 1 ]; then
	echo "Too many arguments"
	exit 1
else
	APP="ffmpeg"
	if [ -z $1 ]; then
		INSTALL_DIR="${PWD}/${APP}"
	else
		INSTALL_DIR="$(readlink -f $1)/${APP}"
	fi
fi

echo -n "Can I install in ${INSTALL_DIR}? [y/N] "
read confirm
# String comparing have to use "=" "!=", not "-eq" "-ne".
if [ "${confirm}" != "y" ]; then
	echo "Installation is interrupted"
	exit 1
fi

mkdir "${INSTALL_DIR}"
if [ $? -ne 0 ]; then
	echo "Cannot make installation directory"
	exit 1
fi

mkdir "${INSTALL_DIR}"/{source,build}

dependency_check

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
echo "You have to set ${INSTALL_DIR}/build/bin to \$PATH to use."
