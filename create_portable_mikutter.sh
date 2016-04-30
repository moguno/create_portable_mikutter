#! /bin/sh -c

pacman -S tar gzip p7zip wget

BASE=`pwd`

TMP=$BASE/aventure
DST=$BASE/portable_mikutter

mkdir $TMP
mkdir $DST

cd $TMP


# Install Ruby
wget http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.2.4-i386-mingw32.7z

7z x ruby-2.2.4-i386-mingw32.7z

mv ruby-2.2.4-i386-mingw32 $DST/ruby


# Install mikutter
wget http://mikutter.hachune.net/bin/mikutter.3.3.8.tar.gz

tar xvf mikutter.3.3.8.tar.gz

mv mikutter $DST


# Bundle
PATH=$DST/ruby/bin:$PATH

cd $DST/mikutter

gem install bundler -v 1.10.6

bundle


# Install Scripts
cd $BASE/scripts
cp -rp * $DST/
