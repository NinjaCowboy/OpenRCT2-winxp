This repository contains a Makefile and source code patch to build OpenRCT2 (v0.4.6 at the time of writing) for Windows XP, as well as precompiled binaries in the [Releases](https://github.com/NinjaCowboy/OpenRCT2-winxp/releases/) section.

# Instructions

Download the OpenRCT2 Windows x86 Portable zip from [here](https://openrct2.org/downloads/releases/latest) and extract it. Go to the [Releases](https://github.com/NinjaCowboy/OpenRCT2-winxp/releases/) section, download the zip, and replace openrct2.exe and openrct2-cli.exe with the ones in the zip you just downloaded.

Networking and multiplayer games are supported! Due to Windows XP not having built-in support for TLS 1.2, libcurl and MbedTLS provide such functionality needed to connect to publicly hosted games. You must download an updated certificate store from [here](https://curl.se/ca/cacert.pem) and place it in the same folder as openrct2.exe.

# Building from source

This Makefile is designed for Unix/Linux environments and will automatically download and compile all libraries needed by OpenRCT2. Install the following prerequisites and simply type `make`.
* cmake
* git
* make
* mingw-w64
* patch
* perl
* wget
