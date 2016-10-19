$ErrorActionPreference = "Stop"

$BASE = Get-Location

$TMP = Join-Path $BASE "aventure"
$DST = Join-path $BASE "portable_mikutter"
$LIB = Join-path $BASE "lib"
$SevenZIP = Join-Path (Join-Path (Join-Path $BASE "tool") "7za920") "7za.exe"
$Gem = Join-Path (Join-Path (Join-Path $DST "ruby") "bin") "gem.cmd"
$GemUpdater = Join-Path (Join-Path (Join-Path $DST "ruby") "bin") "update_rubygems.bat"
$Bundle = Join-Path (Join-Path (Join-Path $DST "ruby") "bin") "bundler.bat"

function 環境変数の設定
{
    $env:HOME=$DST
    $env:PATH=(Join-Path (Join-Path $DST "ruby") "bin") + ":" + $env:PATH
}

function 作業フォルダの初期化
{
    Remove-Item $TMP -Recurse -Force -ErrorAction SilentlyContinue > $null 2>&1
    Remove-Item $DST -Recurse -Force -ErrorAction SilentlyContinue > $null 2>&1

    New-Item $TMP -ItemType Directory -force -ErrorAction SilentlyContinue > $null
    New-Item $DST -ItemType Directory -force -ErrorAction SilentlyContinue > $null
}

function Rubyのインストール
{
    cd  $TMP

    wget -Uri "http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.3.1-i386-mingw32.7z" -OutFile (Join-Path $TMP "ruby.7z")
    & $SevenZIP "x", (Join-Path $TMP "ruby.7z")
    Move-Item (Join-Path $TMP "ruby-2.3.1-i386-mingw32") (Join-Path $DST "ruby")

    & $Gem "install" "rubygems-update" "--source=http://rubygems.org"
    & $GemUpdater
}

function みくったーのインストール
{
    cd  $TMP

    wget -Uri "http://mikutter.hachune.net/bin/mikutter.3.4.6.tar.gz" -OutFile (Join-Path $TMP "mikutter.tar.gz")

    & $SevenZIP "x" (Join-Path $TMP "mikutter.tar.gz")
    & $SevenZIP "x" (Join-Path $TMP "mikutter.tar")
    Move-Item "mikutter" (Join-Path $DST "mikutter")

    # お前、まだあいつ(Linux)のことを・・・俺が忘れさせてやるよ！
    # （vendorディレクトリにLinux用gemが入ってるのを削除する）
    Remove-Item (Join-Path (Join-Path $DST "mikutter") "vendor") -Force -Recurse
}

function Packagedのインストール
{
    cd  $TMP

    wget -Uri "https://github.com/moguno/mikutter-packaged/archive/master.tar.gz" -OutFile (Join-Path $TMP "packaged.tar.gz")
    & $SevenZIP "x" (Join-Path $TMP "packaged.tar.gz")
    & $SevenZIP "x" "-xr0!pax_global_header" (Join-Path $TMP "packaged.tar")
    Move-Item "mikutter-packaged-master" (Join-Path $DST "packaged")

    & $Gem "install" "minitar"
}

function 必須プラグインのインストール
{
    cd  $TMP

    wget -Uri "https://github.com/moguno/mikutter-windows/archive/master.tar.gz" -OutFile (Join-Path $TMP "mikutter-windows.tar.gz")
    & $SevenZIP "x" (Join-Path $TMP "mikutter-windows.tar.gz")
    & $SevenZIP "x" "-xr0!pax_global_header" (Join-Path $TMP "mikutter-windows.tar")
    Move-Item "mikutter-windows-master" (Join-Path (Join-Path (Join-Path $DST "mikutter") "plugin") "mikutter-windows")

    wget -Uri "https://github.com/moguno/mikutter-portable-path/archive/master.tar.gz" -OutFile (Join-Path $TMP "mikutter-portable-path.tar.gz")
    & $SevenZIP "x" (Join-Path $TMP "mikutter-portable-path.tar.gz")
    & $SevenZIP "x" "-xr0!pax_global_header" (Join-Path $TMP "mikutter-portable-path.tar")
    Move-Item "mikutter-portable-path-master" (Join-Path (Join-Path (Join-Path $DST "mikutter") "plugin") "mikutter-portable-path")
}

function Bundle
{
    & $Gem "install" "bundler"

    cd (Join-Path $DST "mikutter")

    & $Bundle
}

function スクリプト類のインストール
{
    cd (Join-Path $BASE "scripts")
    copy * $DST
}

function プラグインディレクトリの作成
{
    New-Item (Join-Path (Join-Path $DST ".mikutter") "plugin") -ItemType Directory -force > $null
}

function 終了処理
{
    cd $BASE
}


try 
{
    環境変数の設定
    作業フォルダの初期化
    Rubyのインストール
    みくったーのインストール
    必須プラグインのインストール
    Bundle
    プラグインディレクトリの作成
    スクリプト類のインストール
    Packagedのインストール
}
catch
{
    echo "しっぱいしちゃった。"
    echo $Error
}
finally
{
    終了処理
}
