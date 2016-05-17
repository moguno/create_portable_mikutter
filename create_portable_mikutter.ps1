$BASE = Get-Location

$TMP = Join-Path $BASE "aventure"
$DST = Join-path $BASE "portable_mikutter"
$LIB = Join-path $BASE "lib"
$SevenZIP = Join-Path (Join-Path (Join-Path $BASE "tool") "7za920") "7za.exe"
$Gem = Join-Path (Join-Path (Join-Path $DST "ruby") "bin") "gem"
$Bundle = Join-Path (Join-Path (Join-Path $DST "ruby") "bin") "bundle"

$env:HOME=$DST
$env:PATH=(Join-Path (Join-Path $DST "ruby") "bin") + ":" + $env:PATH

Remove-Item $TMP -Recurse > $null 2>&1
Remove-Item $DST -Recurse > $null 2>&1

New-Item $TMP -ItemType Directory -force > $null
New-Item $DST -ItemType Directory -force > $null

cd  $TMP

# Install Ruby
wget -Uri "http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.2.4-i386-mingw32.7z" -OutFile (Join-Path $TMP "ruby.7z")
& $SevenZIP "x", (Join-Path $TMP "ruby.7z")
Move-Item (Join-Path $TMP "ruby-2.2.4-i386-mingw32") (Join-Path $DST "ruby")

wget -Uri "http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.2.4-i386-mingw32.7z" -OutFile (Join-Path $TMP "LICENSE.txt")
Move-Item "LICENSE.txt" (Join-Path $DST "ruby")


#Install Mikutter
wget -Uri "http://mikutter.hachune.net/bin/mikutter.3.3.10.tar.gz" -OutFile (Join-Path $TMP "mikutter.tar.gz")

& $SevenZIP "x" (Join-Path $TMP "mikutter.tar.gz")
& $SevenZIP "x" (Join-Path $TMP "mikutter.tar")
Move-Item "mikutter" (Join-Path $DST "mikutter")


# Install packaged
wget -Uri "https://github.com/moguno/mikutter-packaged/archive/master.tar.gz" -OutFile (Join-Path $TMP "packaged.tar.gz")
& $SevenZIP "x" (Join-Path $TMP "packaged.tar.gz")
& $SevenZIP "x" "-xr0!pax_global_header" (Join-Path $TMP "packaged.tar")
Move-Item "mikutter-packaged-master" (Join-Path $DST "packaged")


# Install Plugins
wget -Uri "https://github.com/moguno/mikutter-windows/archive/master.tar.gz" -OutFile (Join-Path $TMP "mikutter-windows.tar.gz")
& $SevenZIP "x" (Join-Path $TMP "mikutter-windows.tar.gz")
& $SevenZIP "x" "-xr0!pax_global_header" (Join-Path $TMP "mikutter-windows.tar")
Move-Item "mikutter-windows-master" (Join-Path (Join-Path (Join-Path $DST "mikutter") "plugin") "mikutter-windows")

wget -Uri "https://github.com/moguno/mikutter-portable-path/archive/master.tar.gz" -OutFile (Join-Path $TMP "mikutter-portable-path.tar.gz")
& $SevenZIP "x" (Join-Path $TMP "mikutter-portable-path.tar.gz")
& $SevenZIP "x" "-xr0!pax_global_header" (Join-Path $TMP "mikutter-portable-path.tar")
Move-Item "mikutter-portable-path-master" (Join-Path (Join-Path (Join-Path $DST "mikutter") "plugin") "mikutter-portable-path")

# Bundle
cd (Join-Path $DST "mikutter")
& $Gem "install" "bundler" "minitar"
& $Bundle

# Install Scripts
cd (Join-Path $BASE "scripts")
copy * $DST

# Create plugin directory
New-Item (Join-Path (Join-Path $DST ".mikutter") "plugin") -ItemType Directory -force > $null

# Finalize
cd $BASE
