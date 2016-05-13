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

  ./build.all.bash
  mv objdir avrdude
  rm -f avrdude-${OUTPUT_VERSION}-${OUTPUT_TAG}.tar.bz2
  tar -cjvf avrdude-${OUTPUT_VERSION}-${OUTPUT_TAG}.tar.bz2 avrdude
  exit 0

elif [[ $OS == "Msys" || $OS == "Cygwin" ]] ; then

  export PATH=$PATH:/c/MinGW/bin/:/c/cygwin/bin/

  CC="mingw32-gcc -m32" CXX="mingw32-g++ -m32" ./build.all.bash
  rm -f *arduino*.tar.bz2 *arduino*.zip
  mv objdir avrdude
  zip -r -9 ./avrdude-${OUTPUT_VERSION}-i686-mingw32.zip avrdude
  exit 0

elif [[ $OS == "Darwin" ]] ; then

  export PATH=/opt/local/libexec/gnubin/:/opt/local/bin:$PATH
  OUTPUT_TAG=i386-apple-darwin11

  CC="gcc -arch i386 -mmacosx-version-min=10.5" CXX="g++ -arch i386 -mmacosx-version-min=10.5" ./build.all.bash
  mv objdir avrdude
  rm -f avrdude-${OUTPUT_VERSION}-${OUTPUT_TAG}.tar.bz2
  tar -cjvf avrdude-${OUTPUT_VERSION}-${OUTPUT_TAG}.tar.bz2 avrdude
  exit 0

else

  echo OS Not supported: $OS
  exit 2

fi

