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

if [[ ! -f libftdi1-1.4.tar.bz2  ]] ;
then
	wget https://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.4.tar.bz2
fi

tar xfv libftdi1-1.4.tar.bz2

rm -rf libftdi1-1.4/build
mkdir libftdi1-1.4/build

cd libftdi1-1.4/
if [[ $OS == "Msys" ]] ; then
  patch -p1 < ../libftdi1-1.4-patches/01-add_sharedlibs_flag.patch
fi
cd build/

CMAKE_EXTRA_FLAG=""

if [[ $OS == "Msys" ]] ; then
  CMAKE_EXTRA_FLAG="$CMAKE_EXTRA_FLAG -DBUILD_TESTS=OFF -DSHAREDLIBS=OFF"
fi

cmake $CMAKE_EXTRA_FLAG -DCMAKE_INSTALL_PREFIX="$PREFIX" -DLIBUSB_INCLUDE_DIR="$PREFIX/include/libusb-1.0" -DLIBFTDI_LIBRARY_DIRS="$PREFIX/lib" -DLIBUSB_LIBRARIES="usb-1.0" ../
make -j 1
make install
cd ../..

