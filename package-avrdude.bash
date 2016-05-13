#!/bin/bash

OUTPUT_VERSION=6.3-arduino

export OS=`uname -o || uname`

if [[ $OS == "GNU/Linux" ]] ; then

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

  export PATH=$PATH:/c/MinGW/bin/:/c/cygwin/bin/
  export CC="mingw32-gcc -m32"
  export CXX="mingw32-g++ -m32"
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

rm -rf avrdude-6.3 libusb-1.0.20 libusb-compat-0.1.5 objdir

./libusb-1.0.20.build.bash
./libusb-compat-0.1.5.build.bash
./avrdude-6.3.build.bash

rm -f avrdude-${OUTPUT_VERSION}-${OUTPUT_TAG}.tar.bz2
tar -cjvf avrdude-${OUTPUT_VERSION}-${OUTPUT_TAG}.tar.bz2 --transform 's,^objdir,avrdude,' objdir

