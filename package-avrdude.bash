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

OUTPUT_VERSION=6.3-arduino

export OS=`uname -o || uname`
export TARGET_OS=$OS

if [[ $CROSS_COMPILE == "mingw" ]] ; then

  export CC="i686-w64-mingw32-gcc"
  export CXX="i686-w64-mingw32-g++"
  export CROSS_COMPILE_HOST="i686-w64-mingw32"
  export TARGET_OS="Windows"
  OUTPUT_TAG=i686-w64-mingw32

elif [[ $OS == "GNU/Linux" ]] ; then

  export MACHINE=`uname -m`
  if [[ $MACHINE == "x86_64" ]] ; then
    OUTPUT_TAG=x86_64-pc-linux-gnu
  elif [[ $MACHINE == "i686" ]] ; then
    OUTPUT_TAG=i686-pc-linux-gnu
  elif [[ $MACHINE == "armv7l" ]] ; then
    OUTPUT_TAG=armhf-pc-linux-gnu
  else
    echo Linux Machine not supported: $MACHINE
    exit 1
  fi

elif [[ $OS == "Msys" || $OS == "Cygwin" ]] ; then

  echo *************************************************************
  echo WARNING: Build on native Cygwin or Msys has been discontinued
  echo you may experience build failure or weird behaviour
  echo *************************************************************

  export PATH=$PATH:/c/MinGW/bin/:/c/cygwin/bin/
  export CC="mingw32-gcc -m32"
  export CXX="mingw32-g++ -m32"
  export TARGET_OS="Windows"
  OUTPUT_TAG=i686-mingw32

elif [[ $OS == "Darwin" ]] ; then

  export PATH=/opt/local/libexec/gnubin/:/opt/local/bin:$PATH
  export CC="gcc -arch i386 -mmacosx-version-min=10.5"
  export CXX="g++ -arch i386 -mmacosx-version-min=10.5"
  OUTPUT_TAG=i386-apple-darwin11

else

  echo OS Not supported: $OS
  exit 2

fi

rm -rf avrdude-6.3 libusb-1.0.20 libusb-compat-0.1.5 libusb-win32-bin-1.2.6.0 libelf-0.8.13 objdir

./libusb-1.0.20.build.bash
./libusb-compat-0.1.5.build.bash
./libelf-0.8.13.build.bash
./avrdude-6.3.build.bash

if [[ $CROSS_COMPILE_HOST == "i686-w64-mingw32" ]] ; then
  # copy dependency libgcc_s_sjlj-1.dll into bin/ folder

  # try to detect the location of libgcc_s_sjlj-1.dll
  # (maybe there is better way... feel free to submit a patch!)
  LTO_PATH=`i686-w64-mingw32-gcc -v 2>&1 | grep LTO | tr '=' ' ' | awk "{ print \\\$2;  }"`
  DLL_PATH=`dirname $LTO_PATH`/libgcc_s_sjlj-1.dll
  cp $DLL_PATH objdir/bin
fi

rm -f avrdude-${OUTPUT_VERSION}-${OUTPUT_TAG}.tar.bz2
cp -a objdir avrdude
tar -cjvf avrdude-${OUTPUT_VERSION}-${OUTPUT_TAG}.tar.bz2 avrdude
rm -r avrdude

