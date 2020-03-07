#!/bin/bash -ex
# Copyright (c) 2014-2016 Arduino LLC
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

OUTPUT_VERSION=6.3.0-arduino17

export OS=`uname -o || uname`
export TARGET_OS=$OS

if [[ $CROSS_COMPILE == "mingw" ]] ; then

  export CC="i686-w64-mingw32-gcc"
  export CXX="i686-w64-mingw32-g++"
  export CROSS_COMPILE_HOST="i686-w64-mingw32"
  export TARGET_OS="Windows"
  OUTPUT_TAG=i686-w64-mingw32

elif [[ $CROSS_COMPILE == "arm64-cross" ]] ; then
  export CC="aarch64-linux-gnu-gcc"
  export CXX="aarch64-linux-gnu-g++"
  export CROSS_COMPILE_HOST="aarch64-linux-gnu"
  export TARGET_OS="GNU/Linux"
  OUTPUT_TAG=aarch64-linux-gnu

elif [[ $CROSS_COMPILE == "arm-cross" ]] ; then
  export CC="arm-linux-gnueabihf-gcc"
  export CXX="arm-linux-gnueabihf-g++"
  export CROSS_COMPILE_HOST="arm-linux-gnueabihf"
  export TARGET_OS="GNU/Linux"
  OUTPUT_TAG=armhf-pc-linux-gnu

elif [[ $OS == "GNU/Linux" ]] ; then

  export MACHINE=`uname -m`
  if [[ $MACHINE == "x86_64" ]] ; then
    OUTPUT_TAG=x86_64-pc-linux-gnu
  elif [[ $MACHINE == "i686" ]] ; then
    OUTPUT_TAG=i686-pc-linux-gnu
  elif [[ $MACHINE == "armv7l" ]] ; then
    OUTPUT_TAG=armhf-pc-linux-gnu
  elif [[ $MACHINE == "aarch64" ]] ; then
    OUTPUT_TAG=aarch64-pc-linux-gnu
  else
    echo Linux Machine not supported: $MACHINE
    exit 1
  fi

elif [[ $OS == "Msys" || $OS == "Cygwin" ]] ; then

  echo *************************************************************
  echo WARNING: Build on native Cygwin or Msys has been discontinued
  echo you may experience build failure or weird behaviour
  echo *************************************************************

export MACHINE=`uname -m`
  if [[ $MACHINE == "x86_64" ]] ; then
    export CC="gcc"
    export CXX="g++"
    export TARGET_OS="Windows"
    OUTPUT_TAG=x86_64-mingw64
  else
    export PATH=$PATH:/c/MinGW/bin/:/c/cygwin/bin/
    export CC="mingw32-gcc -m32"
    export CXX="mingw32-g++ -m32"
    export TARGET_OS="Windows"
    OUTPUT_TAG=i686-mingw32
  fi
elif [[ $OS == "Darwin" ]] ; then

  export PATH=/opt/local/libexec/gnubin/:/opt/local/bin:$PATH
  export CC="gcc -arch x86_64 -mmacosx-version-min=10.8"
  export CXX="g++ -arch x86_64 -mmacosx-version-min=10.8"
  OUTPUT_TAG=x86_64-apple-darwin12

else

  echo OS Not supported: $OS
  exit 2

fi

rm -rf avrdude-6.3 libusb-1.0.20 libusb-compat-0.1.5 libusb-win32-bin-1.2.6.0 libelf-0.8.13 objdir ncurses-5.9 readline-6.3 hidapi

./libusb-1.0.20.build.bash
./libusb-compat-0.1.5.build.bash
./libelf-0.8.13.build.bash
./libncurses-5.9.build.bash
./libhidapi.build.bash
./libftdi-1.4.build.bash
./avrdude-6.3.build.bash

# if producing a windows build, compress as zip and
# copy *toolchain-precompiled* content to any folder containing a .exe
if [[ ${OUTPUT_TAG} == *"mingw"* ]] ; then

  #cp libusb-win32-bin-1.2.6.0/bin/x86/libusb0_x86.dll objdir/bin/libusb0.dll
  rm -f avrdude-${OUTPUT_VERSION}-${OUTPUT_TAG}.zip
  cp -a objdir avrdude
  zip -r avrdude-${OUTPUT_VERSION}-${OUTPUT_TAG}.zip avrdude/bin/ avrdude/etc/avrdude.conf
  rm -r avrdude

else

  rm -f avrdude-${OUTPUT_VERSION}-${OUTPUT_TAG}.tar.bz2
  cp -a objdir avrdude
  tar -cjvf avrdude-${OUTPUT_VERSION}-${OUTPUT_TAG}.tar.bz2 avrdude/bin/avrdude avrdude/etc/avrdude.conf
  rm -r avrdude

fi

