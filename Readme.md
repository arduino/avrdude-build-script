## avrdude build scripts for Arduino/Genuino

This is the build script for the avrdude tool used in the [Arduino IDE](http://arduino.cc/).

The latest version available is 6.3.

As soon as [avrdude ships a new version](http://www.nongnu.org/avrdude/), we pull the source code, **patch it** with some user contributed patches and deliver it with the [Arduino IDE](http://arduino.cc/).
Therefore, the resulting binaries may differ significantly from upstream, you should start blaming us if things are not working as expected :)

### Building

Setup has been done on partially set up development machines. If, trying to compile on your machine, you find any package missing from the following list, please open an issue at once! We all can't afford wasting time on setup :)

#### Debian requirements

```bash
sudo apt-get install build-essential gperf bison subversion texinfo zip automake flex libusb-dev libusb-1.0-0-dev libtinfo-dev pkg-config
```

#### Mac OSX requirements

You need to install MacPorts: https://www.macports.org/install.php. Once done, open a terminal and type:

```bash
sudo port selfupdate
sudo port upgrade outdated
sudo port install wget +universal
sudo port install automake +universal
sudo port install autoconf +universal
sudo port install gpatch +universal
sudo port install libusb +universal
```

#### Windows requirements

You need to install Cygwin: http://www.cygwin.com/. Once you have run `setup-x86.exe`, use the `Search` text field to filter and select for installation the following packages:

- git
- wget
- unzip
- zip
- gperf
- bison
- flex
- make
- patch
- automake
- autoconf
- gcc-g++
- libncurses-devel

You also need to install MinGW: http://www.mingw.org/. Once you have run mingw-get-setup.exe, select and install (clicking on "Installation" -> "Apply changes") the following packages:

- mingw-developer-toolkit
- mingw32-base
- mingw32-gcc-g++
- msys-base
- msys-zip

### Upstream credits

Build process ported from Debian. Thank you guys for your awesome work.

### Credits

Consult the list of contributors [here](https://github.com/arduino/avrdude-build-scripts/graphs/contributors) and [here](https://github.com/arduino/toolchain-avr/graphs/contributors).

### License

The bash scripts are GPLv2 licensed. Every other software used by these bash scripts has its own license. Consult them to know the terms.

