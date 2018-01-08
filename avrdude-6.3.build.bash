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

git clone https://github.com/facchinm/avrdude.git avrdude-6.3 --depth 1

cd avrdude-6.3

patch -p1 < ../avrdude-6.3-patches/90*

export CFLAGS="-I$PREFIX/include -I$PREFIX/include/hidapi -I$PREFIX/include/libelf -I$PREFIX/include/ncurses -I$PREFIX/include/ncursesw -I$PREFIX/include/readline -I$PREFIX/include/libusb-1.0 $CFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"

autoreconf --force --install
./bootstrap
if [[ $OS == "GNU/Linux" ]] ; then
libtoolize
fi

COMMON_FLAGS=""

if [[ $CROSS_COMPILE == "mingw" ]] ; then
CFLAGS="-DHAVE_LIBHIDAPI $CFLAGS -lhidapi -lsetupapi"
LIBS="-lhidapi -lsetupapi"
fi

CONFARGS="--prefix=$PREFIX --enable-linuxgpio"
if [[ $CROSS_COMPILE != "" ]] ; then
  CONFARGS="$CONFARGS --host=$CROSS_COMPILE_HOST"
fi
./configure $CONFARGS CFLAGS="-w -O2 $CFLAGS" CXXFLAGS="-w -O2 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" LIBS="$LIBS"

make
make install
cd ..

