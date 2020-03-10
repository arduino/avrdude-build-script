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

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

if [[ $OS == "Msys" || $OS == "Cygwin" || $CROSS_COMPILE_HOST == "i686-w64-mingw32" ]] ; then
  # libusb-compat is a mess to compile for win32
  # use a precompiled version from libusb-win32 project
  if [[ ! -f libusb-win32-bin-1.2.6.0.zip ]] ; then
    wget http://download.sourceforge.net/project/libusb-win32/libusb-win32-releases/1.2.6.0/libusb-win32-bin-1.2.6.0.zip
  fi
  unzip libusb-win32-bin-1.2.6.0.zip
  mkdir -p $PREFIX/bin/
  cp libusb-win32-bin-1.2.6.0/bin/x86/libusb0_x86.dll $PREFIX/bin/libusb0.dll
  cp libusb-win32-bin-1.2.6.0/include/lusb0_usb.h $PREFIX/include
  cp libusb-win32-bin-1.2.6.0/lib/gcc/libusb.a $PREFIX/lib
  exit 0
fi

if [[ ! -f libusb-compat-0.1.5.tar.bz2 ]] ; then
  wget http://download.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.5/libusb-compat-0.1.5.tar.bz2
fi

tar xfv libusb-compat-0.1.5.tar.bz2

cd libusb-compat-0.1.5
if [[ $OS == "Msys" || $OS == "Cygwin" || $CROSS_COMPILE_HOST == "i686-w64-mingw32" ]] ; then
  patch -p1 < ../libusb-compat-0.1.5-patches/01-mingw-build.patch
  autoreconf --force --install
fi

CONFARGS="--prefix=$PREFIX --enable-static --disable-shared"
if [[ $CROSS_COMPILE != "" ]] ; then
  CONFARGS="$CONFARGS --host=$CROSS_COMPILE_HOST"
fi
PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig" CFLAGS="-w -O2 $CFLAGS" CXXFLAGS="-w -O2 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ./configure $CONFARGS
make -j 1
make install
cd ..

