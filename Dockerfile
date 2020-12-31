FROM debian

RUN apt-get update && apt-get install -y gcc-mingw-w64-i686 g++-mingw-w64-i686 gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 libtool pkg-config bzip2 zip make autoconf gperf wget patch git gcc g++ automake flex bison cmake xsltproc && rm -rf /var/lib/apt/lists/*

COPY . /avrdude-build-script

WORKDIR /avrdude-build-script

ENTRYPOINT ["/avrdude-build-script/package-avrdude.bash"]