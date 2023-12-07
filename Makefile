#############################################################################
# Makefile to automatically build OpenRCT2 and all of its many dependencies #
#############################################################################

# Prerequisites:
#  mingw-w64
#  make
#  wget
#  cmake
#  git
#  patch
#  meson
#  ninja

# non-empty for static build
STATIC ?= 1

CMAKE_BUILD_TYPE ?= Release

TOPDIR := $(shell pwd)
PREFIX_DIR := $(TOPDIR)/build
INSTALL_DIR := $(TOPDIR)/OpenRCT2-winxp

CPU_CORES := 4

CURL_VERSION := 8.5.0
#CURL_VERSION := 8.4.0
CURL_DIR     := curl-$(CURL_VERSION)
CURL_ARCHIVE := $(CURL_DIR).tar.gz

FREETYPE_VERSION := 2.13.2
FREETYPE_DIR     := freetype-$(FREETYPE_VERSION)
FREETYPE_ARCHIVE := $(FREETYPE_DIR).tar.gz

GMP_VERSION := 6.3.0
GMP_DIR     := gmp-$(GMP_VERSION)
GMP_ARCHIVE := $(GMP_DIR).tar.xz

LIBICONV_VERSION := 1.17
LIBICONV_DIR     := libiconv-$(LIBICONV_VERSION)
LIBICONV_ARCHIVE := $(LIBICONV_DIR).tar.gz

LIBPNG_VERSION := 1.6.40
LIBPNG_DIR     := libpng-$(LIBPNG_VERSION)
LIBPNG_ARCHIVE := $(LIBPNG_DIR).tar.gz

LIBTASN1_VERSION := 4.19.0
LIBTASN1_DIR     := libtasn1-$(LIBTASN1_VERSION)
LIBTASN1_ARCHIVE := $(LIBTASN1_DIR).tar.gz

LIBUNISTRING_VERSION := 1.1
LIBUNISTRING_DIR     := libunistring-$(LIBUNISTRING_VERSION)
LIBUNISTRING_ARCHIVE := $(LIBUNISTRING_DIR).tar.gz

LIBZIP_VERSION := 1.10.1
LIBZIP_DIR     := libzip-$(LIBZIP_VERSION)
LIBZIP_ARCHIVE := $(LIBZIP_DIR).tar.gz

MBEDTLS_VERSION := 3.4.1
MBEDTLS_DIR     := mbedtls-$(MBEDTLS_VERSION)
MBEDTLS_ARCHIVE := $(MBEDTLS_DIR).tar.gz

OPENRCT2_DIR := OpenRCT2

OPENSSL_VERSION := 3.2.0
OPENSSL_DIR     := openssl-$(OPENSSL_VERSION)
OPENSSL_ARCHIVE := $(OPENSSL_DIR).tar.gz

P11KIT_VERSION := 0.24.1
P11KIT_DIR     := p11-kit-$(P11KIT_VERSION)
P11KIT_ARCHIVE := $(P11KIT_DIR).tar.xz

NETTLE_VERSION := 3.9.1
NETTLE_DIR     := nettle-$(NETTLE_VERSION)
NETTLE_ARCHIVE := $(NETTLE_DIR).tar.gz

NLOHMANNJSON_VERSION := 3.11.3
NLOHMANNJSON_DIR     := json
NLOHMANNJSON_ARCHIVE := $(NLOHMANNJSON_DIR).tar.xz

SDL2_VERSION := 2.28.5
SDL2_DIR     := SDL-release-$(SDL2_VERSION)
SDL2_ARCHIVE := $(SDL2_DIR).tar.gz

SPEEXDSP_VERSION := 1.2.1
SPEEXDSP_DIR     := speexdsp-$(SPEEXDSP_VERSION)
SPEEXDSP_ARCHIVE := $(SPEEXDSP_DIR).tar.gz

WINPTHREAD_VERSION := 11.0.0
WINPTHREAD_DIR     := mingw-w64-v$(WINPTHREAD_VERSION)
WINPTHREAD_ARCHIVE := $(WINPTHREAD_DIR).tar.bz2

ZLIB_VERSION := 1.3
ZLIB_DIR     := zlib-$(ZLIB_VERSION)
ZLIB_ARCHIVE := $(ZLIB_DIR).tar.gz

CMAKE_CONFIGURE = mkdir -p $(@D)/_build && cd $(@D)/_build && cmake .. -DCMAKE_BUILD_TYPE=$(CMAKE_BUILD_TYPE) -DCMAKE_TOOLCHAIN_FILE=$(TOPDIR)/mingw32.cmake -DCMAKE_INSTALL_PREFIX=$(PREFIX_DIR) -DCMAKE_PREFIX_PATH=$(PREFIX_DIR) -DCMAKE_FIND_ROOT_PATH="/usr/i686-w64-mingw32;$(PREFIX_DIR)"

AUTOTOOLS_CONFIGURE = mkdir -p $(@D)/_build && cd $(@D)/_build && ../configure --host=i686-w64-mingw32 --prefix=$(PREFIX_DIR) CFLAGS="-I$(PREFIX_DIR)/include" LDFLAGS="-L$(PREFIX_DIR)/lib"

.PHONY: all
all: $(OPENRCT2_DIR)/built

.PHONY: install
install: $(OPENRCT2_DIR)/built
	rm -rf $(INSTALL_DIR) && mkdir $(INSTALL_DIR)
	cp \
		$(OPENRCT2_DIR)/_build/openrct2.exe \
		$(OPENRCT2_DIR)/_build/openrct2-cli.exe \
		$(PREFIX_DIR)/bin/SDL2.dll \
		$(PREFIX_DIR)/bin/libpng16.dll \
		$(PREFIX_DIR)/bin/libwinpthread-1.dll \
		$(PREFIX_DIR)/bin/libspeexdsp-1.dll \
		$(PREFIX_DIR)/bin/libzip.dll \
		/usr/i686-w64-mingw32/lib/libgcc_s_sjlj-1.dll \
		/usr/i686-w64-mingw32/lib/libssp-0.dll \
		/usr/i686-w64-mingw32/lib/libstdc++-6.dll \
		$(INSTALL_DIR)
	cp -r $(OPENRCT2_DIR)/data $(INSTALL_DIR)

# Removes all build artifacts (but not downloaded files)
.PHONY: clean
clean:
	$(RM) -r build i686-w64-mingw32-pkg-config $(CURL_DIR) $(FREETYPE_DIR) $(GMP_DIR) $(LIBICONV_DIR) $(LIBPNG_DIR) $(LIBTASN1_DIR) $(LIBUNISTRING_DIR) $(LIBZIP_DIR) $(MBEDTLS_DIR) $(NETTLE_DIR) $(NLOHMANNJSON_DIR) $(OPENRCT2_DIR) $(OPENSSL_DIR) $(P11KIT_DIR) $(SDL2_DIR) $(SPEEXDSP_DIR) $(WINPTHREAD_DIR) $(ZLIB_DIR)

# Removes all build artifacts and downloaded files
.PHONY: distclean
distclean: clean
	$(RM) $(CURL_ARCHIVE) $(FREETYPE_ARCHIVE) $(GMP_ARCHIVE) $(LIBICONV_ARCHIVE) $(LIBPNG_ARCHIVE) $(LIBTASN1_ARCHIVE) $(LIBUNISTRING_ARCHIVE) $(LIBZIP_ARCHIVE) $(MBEDTLS_ARCHIVE) $(NETTLE_ARCHIVE) $(NLOHMANNJSON_ARCHIVE) $(OPENSSL_ARCHIVE) $(P11KIT_ARCHIVE) $(SDL2_ARCHIVE) $(SPEEXDSP_ARCHIVE) $(WINPTHREAD_ARCHIVE) $(ZLIB_ARCHIVE)

$(OPENRCT2_DIR)/extracted:
	git clone --depth 1 --branch v0.4.6 https://github.com/OpenRCT2/OpenRCT2
	cd $(@D) && patch -f -p1 < ../xp-compat.patch
	touch $@

$(OPENRCT2_DIR)/configured: $(OPENRCT2_DIR)/extracted $(CURL_DIR)/installed $(FREETYPE_DIR)/installed $(GMP_DIR)/installed $(LIBICONV_DIR)/installed $(LIBPNG_DIR)/installed $(LIBTASN1_DIR)/installed $(LIBUNISTRING_DIR)/installed $(LIBZIP_DIR)/installed $(MBEDTLS_DIR)/installed $(NETTLE_DIR)/installed $(NLOHMANNJSON_DIR)/installed $(OPENSSL_DIR)/installed $(SDL2_DIR)/installed $(SPEEXDSP_DIR)/installed $(WINPTHREAD_DIR)/installed $(ZLIB_DIR)/installed i686-w64-mingw32-pkg-config
	mkdir -p $(@D)/_build && cd $(@D)/_build && cmake .. -DCMAKE_TOOLCHAIN_FILE=../CMakeLists_mingw.txt -DCMAKE_INSTALL_PREFIX="$(PREFIX_DIR)" -DCMAKE_PREFIX_PATH="$(PREFIX_DIR)" -DCMAKE_CXX_FLAGS="-I$(PREFIX_DIR)/include -I$(PREFIX_DIR)/include/SDL2 -fpermissive $(if $(STATIC),-DCURL_STATICLIB,)" -DDISABLE_DISCORD_RPC=ON -DDISABLE_FLAC=ON -DDISABLE_NETWORK=OFF -DDISABLE_VORBIS=ON -DDOWNLOAD_OPENMSX=OFF -DDOWNLOAD_OPENSFX=OFF -DENABLE_SCRIPTING=OFF -DCMAKE_EXE_LINKER_FLAGS="-L$(PREFIX_DIR)/lib" -DPKG_CONFIG_EXECUTABLE="$(TOPDIR)/i686-w64-mingw32-pkg-config" -DSTATIC=$(if $(STATIC),ON,OFF) -DPORTABLE=ON --debug-find -DCMAKE_LIBRARY_PATH="$(PREFIX_DIR)" -DCMAKE_INCLUDE_PATH="$(PREFIX_DIR)" -DCMAKE_FIND_USE_CMAKE_SYSTEM_PATH=FALSE -DCMAKE_BUILD_TYPE=$(CMAKE_BUILD_TYPE)
	sed -e 's/-mwindows//' -i $(OPENRCT2_DIR)/_build/CMakeFiles/openrct2.dir/linkLibs.rsp
	touch $@

# Curl

$(CURL_ARCHIVE):
	wget https://curl.se/download/$@

# I can't seem to get OpenSSL to statically link, so we use mbedtls instead. It's much smaller, too!
$(CURL_DIR)/configured: $(CURL_DIR)/extracted $(MBEDTLS_DIR)/installed $(ZLIB_DIR)/installed
	$(CMAKE_CONFIGURE) -DCURL_USE_MBEDTLS=ON -DCURL_USE_OPENSSL=OFF -DBUILD_TESTING=OFF -DCURL_TARGET_WINDOWS_VERSION=0x501 -DBUILD_STATIC_LIBS=ON -DBUILD_SHARED_LIBS=$(if $(STATIC),OFF,ON) -DBUILD_CURL_EXE=OFF --debug-find
#	$(AUTOTOOLS_CONFIGURE) --enable-shared --enable-static --with-openssl
	touch $@

# Freetype

$(FREETYPE_ARCHIVE):
	wget https://download.savannah.gnu.org/releases/freetype/$@

$(FREETYPE_DIR)/configured: $(FREETYPE_DIR)/extracted
	$(CMAKE_CONFIGURE)
	touch $@

# GMP

$(GMP_ARCHIVE):
	wget https://gmplib.org/download/gmp/$@

$(GMP_DIR)/configured: $(GMP_DIR)/extracted
	$(AUTOTOOLS_CONFIGURE)
	touch $@

# libiconv

$(LIBICONV_ARCHIVE):
	wget https://ftp.gnu.org/pub/gnu/libiconv/$@

$(LIBICONV_DIR)/configured: $(LIBICONV_DIR)/extracted
	$(AUTOTOOLS_CONFIGURE) --enable-static
	touch $@

# libpng

$(LIBPNG_ARCHIVE):
	wget https://download.sourceforge.net/libpng/$@

$(LIBPNG_DIR)/configured: $(LIBPNG_DIR)/extracted $(ZLIB_DIR)/installed
	$(CMAKE_CONFIGURE) -DPNG_SHARED=$(if $(STATIC),OFF,ON) -DPNG_TESTS=OFF -DPNG_EXECUTABLES=OFF
	touch $@

# libtasn1

$(LIBTASN1_ARCHIVE):
	wget https://ftp.gnu.org/gnu/libtasn1/$@

$(LIBTASN1_DIR)/configured: $(LIBTASN1_DIR)/extracted
	$(AUTOTOOLS_CONFIGURE)
	touch $@

# libunistring

$(LIBUNISTRING_ARCHIVE):
	wget https://ftp.gnu.org/gnu/libunistring/$@

$(LIBUNISTRING_DIR)/configured: $(LIBUNISTRING_DIR)/extracted
	$(AUTOTOOLS_CONFIGURE)
	touch $@

# libzip

$(LIBZIP_ARCHIVE):
	wget https://libzip.org/download/$@

$(LIBZIP_DIR)/configured: $(LIBZIP_DIR)/extracted
	$(CMAKE_CONFIGURE) -DENABLE_WINDOWS_CRYPTO=OFF -DENABLE_OPENSSL=OFF -DENABLE_MBEDTLS=OFF -DENABLE_ZSTD=OFF -DBUILD_SHARED_LIBS=$(if $(STATIC),OFF,ON) && sed -e '/HAVE_.*_S$$/s/define/undef/' -e '$$a#define _INC_STDIO_S' -i config.h
	touch $@

# mbedtls

$(MBEDTLS_ARCHIVE):
	wget https://github.com/Mbed-TLS/mbedtls/archive/refs/tags/v$(MBEDTLS_VERSION).tar.gz -O $@

$(MBEDTLS_DIR)/extracted: $(MBEDTLS_ARCHIVE)
	tar xvf $<
	sed -e 's/#if defined(_TRUNCATE)/#if 0/' -i $(MBEDTLS_DIR)/library/platform.c
	touch $@

$(MBEDTLS_DIR)/configured: $(MBEDTLS_DIR)/extracted
	$(CMAKE_CONFIGURE) -DENABLE_PROGRAMS=OFF -DENABLE_TESTING=OFF
	touch $@

# Nettle

$(NETTLE_ARCHIVE):
	wget https://ftp.gnu.org/gnu/nettle/$@

# GMP must be installed first in order to build libhogweed
$(NETTLE_DIR)/configured: $(NETTLE_DIR)/extracted $(GMP_DIR)/installed
	$(AUTOTOOLS_CONFIGURE)
	touch $@

# nlohmann JSON

#$(NLOHMANNJSON_ARCHIVE):
#	wget https://github.com/nlohmann/json/releases/download/v$(NLOHMANNJSON_VERSION)/$@

# stable version is broken (won't build), so download the git repo instead
$(NLOHMANNJSON_DIR)/extracted:
	git clone https://github.com/nlohmann/json --depth 1
	touch $@

$(NLOHMANNJSON_DIR)/configured: $(NLOHMANNJSON_DIR)/extracted
	$(CMAKE_CONFIGURE) -DBUILD_TESTING=OFF -DJSON_BuildTests=OFF
	touch $@

# OpenSSL

$(OPENSSL_ARCHIVE):
	wget https://www.openssl.org/source/$@

$(OPENSSL_DIR)/configured: $(OPENSSL_DIR)/extracted
	mkdir -p $(@D)/_build && cd $(@D)/_build && ../Configure mingw --prefix="$(PREFIX_DIR)" --cross-compile-prefix=i686-w64-mingw32- no-tests no-docs no-dso no-module $(if $(STATIC),no-shared,) -D_WIN32_WINNT=0x501
	touch $@

# p11-kit

$(P11KIT_ARCHIVE):
	wget https://github.com/p11-glue/p11-kit/releases/download/$(P11KIT_VERSION)/$@

$(P11KIT_DIR)/configured: $(P11KIT_DIR)/extracted
	cd $(@D) && meson setup --reconfigure --prefix "$(PREFIX_DIR)" --cross-file $(TOPDIR)/mingw32.meson _build
	touch $@

$(P11KIT_DIR)/built: $(P11KIT_DIR)/configured
	meson compile -C $(@D)/_build
	touch $@

$(P11KIT_DIR)/installed: $(P11KIT_DIR)/built
	meson install -C $(@D)/_build
	touch $@

# SDL2

$(SDL2_ARCHIVE):
	wget https://github.com/libsdl-org/SDL/archive/refs/tags/release-$(SDL2_VERSION).tar.gz -O $@

$(SDL2_DIR)/configured: $(SDL2_DIR)/extracted
	$(CMAKE_CONFIGURE) $(if $(STATIC),-DSDL_SHARED=OFF,)
	touch $@

# Speex DSP

$(SPEEXDSP_ARCHIVE):
	wget http://downloads.xiph.org/releases/speex/$@

$(SPEEXDSP_DIR)/configured: $(SPEEXDSP_DIR)/extracted
	$(AUTOTOOLS_CONFIGURE) $(if $(STATIC),--disable-shared)
	touch $@

# Winpthread

$(WINPTHREAD_ARCHIVE):
	wget https://newcontinuum.dl.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/$@

$(WINPTHREAD_DIR)/configured: $(WINPTHREAD_DIR)/extracted
	mkdir -p $(@D)/_build && cd $(@D)/_build && ../mingw-w64-libraries/winpthreads/configure --host=i686-w64-mingw32 --prefix=$(PREFIX_DIR) CFLAGS="-I$(PREFIX_DIR)/include -D_WIN32_WINNT=0x501" LDFLAGS="-L$(PREFIX_DIR)/lib"
	touch $@

# Zlib

$(ZLIB_ARCHIVE):
	wget https://www.zlib.net/$@

$(ZLIB_DIR)/configured: $(ZLIB_DIR)/extracted
	$(CMAKE_CONFIGURE)
	touch $@

$(ZLIB_DIR)/installed: $(ZLIB_DIR)/built
	cd $(@D)/_build && make install
	ln -rsf build/lib/libzlibstatic.a build/lib/libz.a
	touch $@

# pkg-config

i686-w64-mingw32-pkg-config:
	rm -f $@
	echo 'PKG_CONFIG_SYSROOT_DIR=$(PREFIX_DIR)/lib/pkgconfig' >> $@
	echo 'PKG_CONFIG_LIBDIR=$$PKG_CONFIG_SYSROOT_DIR' >> $@
	echo 'export PKG_CONFIG_PATH=$$PKG_CONFIG_SYSROOT_DIR:$(PREFIX_DIR)/share/pkgconfig' >> $@
	echo 'pkg-config --env-only $$@' >> $@
	chmod +x $@

# Generic recipes

%/extracted: %.tar.gz
	tar xvf $<
	touch $@

%/extracted: %.tar.xz
	tar xvf $<
	touch $@

%/extracted: %.tar.bz2
	tar xvf $<
	touch $@

%/built: %/configured
	cd $(@D)/_build && make -j$(CPU_CORES)
	touch $@

%/installed: %/built
	cd $(@D)/_build && make install
	touch $@
