#!/bin/bash
#Install script for applications
#MakeMKV-RDP

#####################################
#	Install dependencies			#
#									#
#####################################

apt-get update -qq
apt-get install -qy build-essential pkg-config libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev libqt4-dev wget

#####################################
#	Download sources and extract	#
#									#
#####################################
VERSION="1.9.9"

mkdir -p /tmp/sources
wget -O /tmp/sources/makemkv-bin-$VERSION.tar.gz http://www.makemkv.com/download/makemkv-bin-$VERSION.tar.gz
wget -O /tmp/sources/makemkv-oss-$VERSION.tar.gz http://www.makemkv.com/download/makemkv-oss-$VERSION.tar.gz
wget -O /tmp/sources/ffmpeg-2.8.tar.bz2 https://ffmpeg.org/releases/ffmpeg-2.8.tar.bz2
pushd /tmp/sources/
tar xvzf /tmp/sources/makemkv-bin-$VERSION.tar.gz
tar xvzf /tmp/sources/makemkv-oss-$VERSION.tar.gz
tar xvjf /tmp/sources/ffmpeg-2.8.tar.bz2
cp /tmp/ask_eula.sh /tmp/sources/makemkv-bin-$VERSION/src/ 
cp /tmp/Makefile /tmp/sources/makemkv-bin-$VERSION/
popd

#####################################
#	Compile and install				#
#									#
#####################################

#FFmpeg
pushd /tmp/sources/ffmpeg-2.8
./configure --prefix=/tmp/ffmpeg --enable-static --disable-shared --enable-pic --disable-yasm
make install
popd

#Makemkv-oss
pushd /tmp/sources/makemkv-oss-$VERSION
PKG_CONFIG_PATH=/tmp/ffmpeg/lib/pkgconfig ./configure
make
make install
popd

#Makemkv-bin
pushd /tmp/sources/makemkv-bin-$VERSION
make install
popd

#####################################
#	Remove unneeded packages		#
#									#
#####################################

apt-get remove -qy build-essential pkg-config libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev libqt4-dev
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

exit
