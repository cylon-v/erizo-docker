FROM ubuntu:14.04
MAINTAINER Cylon V https://github.com/cylon-v

RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:chris-lea/node.js
RUN apt-get -y update

RUN apt-get -y install python-software-properties software-properties-common git make gcc g++ libssl-dev cmake libglib2.0-dev pkg-config nodejs libboost-regex-dev libboost-thread-dev libboost-system-dev liblog4cxx10-dev rabbitmq-server mongodb openjdk-6-jre curl libboost-test-dev yasm libvpx. libx264.

RUN npm install -g node-gyp

RUN mkdir -p /app/licode
WORKDIR /app/licode
RUN curl -L https://github.com/ging/licode/archive/v1.1.0.tar.gz > licode.tar.gz
RUN tar -zxvf licode.tar.gz --strip-components=1
RUN rm licode.tar.gz

RUN mkdir -p /app/licode/build/libdeps
RUN mkdir -p /app/licode/build/libdeps/build

WORKDIR /app/licode/build/libdeps
RUN curl -O http://www.openssl.org/source/openssl-1.0.1g.tar.gz
RUN tar -zxvf openssl-1.0.1g.tar.gz
WORKDIR /app/licode/build/libdeps/openssl-1.0.1g
RUN ./config --prefix=/app/licode/build/libdeps/build -fPIC
RUN make -s V=0
RUN make install_sw

WORKDIR /app/licode/build/libdeps
RUN curl -O http://nice.freedesktop.org/releases/libnice-0.1.4.tar.gz
RUN tar -zxvf libnice-0.1.4.tar.gz
WORKDIR /app/licode/build/libdeps/libnice-0.1.4
RUN patch -R ./agent/conncheck.c < /app/licode/scripts/libnice-014.patch0
RUN ./configure --prefix=/app/licode/build/libdeps/build
RUN make -s V=0
RUN make install

WORKDIR /app/licode/third_party/srtp
RUN CFLAGS="-fPIC" ./configure --prefix=/app/licode/build/libdeps/build
RUN make -s V=0
RUN make uninstall
RUN make install

WORKDIR /app/licode/build/libdeps
RUN curl -O http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz
RUN tar -zxvf opus-1.1.tar.gz
WORKDIR /app/licode/build/libdeps/opus-1.1
RUN ./configure --prefix=/app/licode/build/libdeps/build
RUN make -s V=0
RUN make install

WORKDIR /app/licode/build/libdeps
RUN curl -O https://www.libav.org/releases/libav-9.13.tar.gz
RUN tar -zxvf libav-9.13.tar.gz
WORKDIR /app/licode/build/libdeps/libav-9.13
RUN PKG_CONFIG_PATH=/app/licode/build/libdeps/build/lib/pkgconfig ./configure --prefix=/app/licode/build/libdeps/build --enable-shared --enable-gpl --enable-libvpx --enable-libx264 --enable-libopus
RUN make -s V=0
RUN make install

WORKDIR /app/licode/erizo
ADD patch/CMakeLists.txt /app/licode/erizo/src/CMakeLists.txt
RUN ./generateProject.sh
RUN ./buildProject.sh

WORKDIR /app/licode/erizoAPI
ENV ERIZO_HOME=/app/licode/erizo 
ENV LD\_LIBRARY\_PATH=/app/licode/erizo/build/erizo 
RUN ./build.sh

ADD app/* /app/
WORKDIR /app
ENTRYPOINT /bin/bash
