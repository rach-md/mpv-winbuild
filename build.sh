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
    mkdir -p ./release
    package
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
    cd $gitdir/release
    for dir in ./mpv*$arch*; do
        if [ -d $dir ]; then
            7z a -m0=lzma2 -mx=9 -ms=on mpv.7z $dir/* -x!*.7z
            rm -rf $dir
        fi
    done
    cd ..
}

while getopts e: flag
do
    case "${flag}" in
        e) extra_option=${OPTARG};;
    esac
done

main
