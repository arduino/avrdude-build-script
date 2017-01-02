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

if [[ ! -f ncurses-6.0.tar.gz  ]] ;
then
	wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.0.tar.gz
fi

tar xfv ncurses-6.0.tar.gz

cd ncurses-6.0
CONFARGS="--prefix=$PREFIX --disable-shared --without-debug --without-ada --enable-widec --with-cxx-binding"
if [[ $CROSS_COMPILE != "" ]] ; then
  CONFARGS="$CONFARGS --host=$CROSS_COMPILE_HOST"
  # solve bug with --host not being effective on second level directory
  export CC=$CROSS_COMPILE_HOST-gcc
  export AR=$CROSS_COMPILE_HOST-ar
  export RANLIB=$CROSS_COMPILE_HOST-ranlib
fi
CFLAGS="-w -O2 $CFLAGS -fPIC" CXXFLAGS="-w -O2 $CXXFLAGS -fPIC" LDFLAGS="-s $LDFLAGS -fPIC" ./configure $CONFARGS
make -j 4
make install
cd ..

if [[ ! -f readline-7.0.tar.gz  ]] ;
then
        wget https://ftp.gnu.org/gnu/readline/readline-7.0.tar.gz
fi

tar xfv readline-7.0.tar.gz

cd readline-7.0
CONFARGS="--prefix=$PREFIX --disable-shared"
if [[ $CROSS_COMPILE != "" ]] ; then
  CONFARGS="$CONFARGS --host=$CROSS_COMPILE_HOST"
  # solve bug with --host not being effective on second level directory
  export CC=$CROSS_COMPILE_HOST-gcc
  export AR=$CROSS_COMPILE_HOST-ar
  export RANLIB=$CROSS_COMPILE_HOST-ranlib
fi
CFLAGS="-w -O2 $CFLAGS -fPIC" CXXFLAGS="-w -O2 $CXXFLAGS -fPIC" LDFLAGS="-s $LDFLAGS -fPIC" ./configure $CONFARGS
make -j 4
make install
cd ..

