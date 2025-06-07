#!/bin/bash
set -x

main() {
    gitdir=$(pwd)
    clang_root=$(pwd)/clang_root
    buildroot=$(pwd)
    srcdir=$(pwd)/src_packages
    bit="64"
    arch="x86_64"
    compiler="clang"
    simple_package=$1

    prepare
    package
    rm -rf ./release/mpv-packaging-master
}

package() {
    build $bit $arch
    zip $bit $arch
    sudo rm -rf $buildroot/build$bit/mpv-*
    sudo chmod -R a+rwx $buildroot/build$bit
}

build() {
    cmake -Wno-dev --fresh -DTARGET_ARCH=$arch-w64-mingw32 -DCOMPILER_TOOLCHAIN=$compiler -DCMAKE_INSTALL_PREFIX=$clang_root -DMINGW_INSTALL_PREFIX=$buildroot/build$bit/install/$arch-w64-mingw32 -DCLANG_PACKAGES_LTO=ON $extra_option -DENABLE_CCACHE=ON -DSINGLE_SOURCE_LOCATION=$srcdir -DRUSTUP_LOCATION=$buildroot/install_rustup -G Ninja -H$gitdir -B$buildroot/build$bit

    ninja -C $buildroot/build$bit download || true

    if [ ! "$(ls -A $clang_root/bin/clang)" ]; then
        ninja -C $buildroot/build$bit llvm && ninja -C $buildroot/build$bit llvm-clang
    fi

    if [[ ! "$(ls -A $buildroot/install_rustup/.cargo/bin)" ]]; then
        ninja -C $buildroot/build$bit rustup-fullclean
        ninja -C $buildroot/build$bit rustup
    fi
    ninja -C $buildroot/build$bit update
    ninja -C $buildroot/build$bit mpv-fullclean
    
    ninja -C $buildroot/build$bit mpv

    if [ -n "$(find $buildroot/build$bit -maxdepth 1 -type d -name "mpv*$arch*" -print -quit)" ] ; then
        echo "Successfully compiled $bit-bit. Continue"
    else
        echo "Failed compiled $bit-bit. Stop"
        exit 1
    fi
    
    ninja -C $buildroot/build$bit cargo-clean
}

zip() {
    mv $buildroot/build$bit/mpv-* $gitdir/release
    if [ "$simple_package" != "true" ]; then
        cd $gitdir/release/mpv-packaging-master
        cp -r ./mpv-root/* ../mpv-$arch*
    fi
    cd $gitdir/release
    for dir in ./mpv*$arch*; do
        if [ -d $dir ]; then
            7z a -m0=lzma2 -mx=9 -ms=on $dir.7z $dir/* -x!*.7z
            rm -rf $dir
        fi
    done
    cd ..
}

download_mpv_package() {
    local package_url="https://codeload.github.com/zhongfly/mpv-packaging/zip/master"
    if [ -e mpv-packaging.zip ]; then
        echo "Package exists. Check if it is newer.."
        remote_commit=$(git ls-remote https://github.com/zhongfly/mpv-packaging.git master | awk '{print $1;}')
        local_commit=$(unzip -z mpv-packaging.zip | tail +2)
        if [ "$remote_commit" != "$local_commit" ]; then
            wget -qO mpv-packaging.zip $package_url
        fi
    else
        wget -qO mpv-packaging.zip $package_url
    fi
    unzip -o mpv-packaging.zip
}

prepare() {
    mkdir -p ./release
    if [ "$simple_package" != "true" ]; then
        cd ./release
        download_mpv_package
        cd ./mpv-packaging-master
        cd ../..
    fi
}

while getopts s:e: flag
do
    case "${flag}" in
        s) simple_package=${OPTARG};;
        e) extra_option=${OPTARG};;
    esac
done

main "${simple_package:-false}"
