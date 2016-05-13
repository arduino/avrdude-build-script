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

if [[ ! -f avrdude-6.3.tar.gz  ]] ;
then
	wget http://download.savannah.gnu.org/releases/avrdude/avrdude-6.3.tar.gz
fi

tar xfv avrdude-6.3.tar.gz

cd avrdude-6.3
for p in ../avrdude-patches/*.patch; do echo Applying $p; patch -p0 < $p; done
autoreconf --force --install
./bootstrap
cd -

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

CFLAGS="$CFLAGS -I$PREFIX/include -I$PREFIX/include/libusb-1.0/ -L$PREFIX/lib"
CXXFLAGS="$CXXFLAGS -I$PREFIX/include -I$PREFIX/include/libusb-1.0/ -L$PREFIX/lib"
LDFLAGS="$LDFLAGS -I$PREFIX/include -I$PREFIX/include -L$PREFIX/lib"

mkdir -p avrdude-build
cd avrdude-build
CONFARGS="--prefix=$PREFIX --enable-linuxgpio"
CFLAGS="-w -O2 $CFLAGS" CXXFLAGS="-w -O2 $CXXFLAGS" LDFLAGS="-s $LDFLAGS" ../avrdude-6.3/configure $CONFARGS
make
make install

if [ `uname -s` == "Linux" ] || [ `uname -s` == "Darwin" ]
then
	cd ../objdir/bin/
	mv avrdude avrdude_bin
	cp ../../avrdude-files/avrdude .
	if [ `uname -s` == "Darwin" ]
	then
		sed -i '' 's/LD_LIBRARY_PATH/DYLD_LIBRARY_PATH/g' avrdude
	fi
fi
