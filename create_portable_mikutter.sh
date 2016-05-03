#! /bin/sh -c

pacman -S tar gzip p7zip wget unzip

BASE=`pwd`

TMP=$BASE/aventure
DST=$BASE/portable_mikutter

rm -rf $TMP
rm -rf $DST

mkdir $TMP
mkdir $DST

cd $TMP


# Install Ruby
wget http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.2.4-i386-mingw32.7z

7z x ruby-2.2.4-i386-mingw32.7z

mv ruby-2.2.4-i386-mingw32 $DST/ruby

wget https://github.com/oneclick/rubyinstaller/blob/master/LICENSE.txt

mv LICENSE.txt $DST/ruby


# Install mikutter
wget http://mikutter.hachune.net/bin/mikutter.3.3.8.tar.gz

tar xvf mikutter.3.3.8.tar.gz

mv mikutter $DST


# Install packaged
wget https://github.com/moguno/mikutter-packaged/archive/master.zip

unzip master.zip

mv mikutter-packaged-master $DST/packaged

rm master.zip


# Install Plugins
wget https://github.com/moguno/mikutter-portable-path/archive/master.zip

unzip master.zip

mv mikutter-portable-path-master $DST/mikutter/plugin/mikutter-portable-path

rm master.zip


wget https://github.com/moguno/mikutter-windows/archive/master.zip

unzip master.zip

mv mikutter-windows-master $DST/mikutter/plugin/mikutter-windows

rm master.zip


# Bundle
PATH=$DST/ruby/bin:$PATH

cd $DST/mikutter

gem install bundler

bundle


# Install Scripts
cd $BASE/scripts
cp -rp * $DST/


# Create plugin directory
mkdir -p $DST/.mikutter/plugin
