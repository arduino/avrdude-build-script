#!/bin/bash

OS=`uname -o || uname`

if [[ $OS == "GNU/Linux" ]] ;
then
  MACHINE=`uname -m`
  if [[ $MACHINE == "x86_64" ]] ; then
    ./arch.linux64.build.bash
    exit 0
  fi

  if [[ $MACHINE == "i686" ]] ; then
    ./arch.linux32.build.bash
    exit 0
  fi

  if [[ $MACHINE == "armv7l" ]] ; then
    ./arch.arm.build.bash
    exit 0
  fi

  echo Linux Machine not supported: $MACHINE
  exit 1
fi

if [[ $OS == "Msys" || $OS == "Cygwin" ]] ;
then
  ./arch.win32.build.bash
  exit 0
fi

if [[ $OS == "Darwin" ]] ;
then
  ./arch.mac.build.bash
  exit 0
fi

echo OS Not supported: $OS
exit 2

