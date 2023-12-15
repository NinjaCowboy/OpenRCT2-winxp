This repository contains a Makefile and source code patch to build OpenRCT2 (v0.4.6 at the time of writing) for Windows XP, as well as precompiled binaries in the [Releases](https://github.com/NinjaCowboy/OpenRCT2-winxp/releases/) section.

# Instructions

Download the OpenRCT2 Windows x86 Portable zip from [here](https://openrct2.org/downloads/releases/latest) and extract it. Go to the [Releases](https://github.com/NinjaCowboy/OpenRCT2-winxp/releases/) section, download the zip, and replace openrct2.exe and openrct2-cli.exe with the ones in the zip you just downloaded.

Networking and multiplayer games are supported! Due to Windows XP not having built-in support for TLS 1.2, libcurl and MbedTLS provide such functionality needed to connect to publicly hosted games. You must download an updated certificate store from [here](https://curl.se/ca/cacert.pem) and place it in the same folder as openrct2.exe.

# Building from source

This Makefile is designed for Unix/Linux environments and will automatically download and compile all libraries needed by OpenRCT2. Install the following prerequisites and simply type `make`.
* bzip2
* cmake
* git
* make
* mingw-w64
* patch
* perl
* wget
* m4
* pkgconf (note: *not* pkg-config)

## Debian/Ubuntu

On Debian or Ubuntu, mingw-w64 comes with support for two different threading models: win32 and posix. The C++ thread library only works with the posix threading model, though win32 is selected by defaut. To fix this, run `sudo update-alternatives --config i686-w64-mingw32-gcc` and `sudo update-alternatives --config i686-w64-mingw32-g++`, and select the option with the `-posix` suffix.
