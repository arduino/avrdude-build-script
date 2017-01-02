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

if [[ ! -f avrdude-6.3.tar.gz  ]] ;
then
	wget http://download.savannah.gnu.org/releases/avrdude/avrdude-6.3.tar.gz
fi

tar xfv avrdude-6.3.tar.gz

cd avrdude-6.3
for p in ../avrdude-6.3-patches/*.patch; do echo Applying $p; patch -p0 < $p; done
autoreconf --force --install
./bootstrap

CFLAGS="$CFLAGS -I$PREFIX/include -I$PREFIX/ncurses -I$PREFIX/ncursesw -I$PREFIX/readline -I$PREFIX/include/libusb-1.0/ -L$PREFIX/lib"
CXXFLAGS="$CXXFLAGS -I$PREFIX/include -I$PREFIX/ncurses -I$PREFIX/ncursesw -I$PREFIX/readline -I$PREFIX/include/libusb-1.0/ -L$PREFIX/lib"
LDFLAGS="$LDFLAGS -I$PREFIX/include -I$PREFIX/ncurses -I$PREFIX/ncursesw -I$PREFIX/readline -I$PREFIX/include/libusb-1.0/ -L$PREFIX/lib"
CONFARGS="--prefix=$PREFIX --enable-linuxgpio"
if [[ $CROSS_COMPILE != "" ]] ; then
  CONFARGS="$CONFARGS --host=$CROSS_COMPILE_HOST"
fi
CFLAGS="-w -O2 $CFLAGS" CXXFLAGS="-w -O2 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ./configure $CONFARGS

make
make install
cd ..

