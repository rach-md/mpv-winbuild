ExternalProject_Add(ffmpeg
    DEPENDS
        zlib
        libjxl
        dav1d
    GIT_REPOSITORY https://github.com/FFmpeg/FFmpeg.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--sparse --filter=tree:0"
    GIT_CLONE_POST_COMMAND "sparse-checkout set --no-cone /* !tests/ref/fate"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 <SOURCE_DIR>/configure
        --cross-prefix=${TARGET_ARCH}-
        --prefix=${MINGW_INSTALL_PREFIX}
        --arch=${TARGET_CPU}
        --target-os=mingw32
        --pkg-config=pkgconf
        --pkg-config-flags=--static
        --enable-cross-compile
        --enable-runtime-cpudetect
        --disable-autodetect
        --enable-zlib
        --enable-libdav1d
        --enable-libjxl
        --enable-schannel
        --enable-d3d11va
        --enable-dxva2
        --disable-doc
        --disable-programs
        --disable-debug
        --disable-avdevice
        --disable-muxers
        --disable-demuxer=matroska
        --disable-devices
        --disable-bsfs
        --disable-filters
        --enable-filter=aresample,dynaudnorm
        --disable-encoders
        --disable-decoder=aac_fixed,ac3_fixed,mp1,mp2,mp3,mp3adu,mp3on4
        --enable-lto=thin
        --extra-cflags='-Wno-error=int-conversion'
        "--extra-libs='-lc++'" # -lc++ needs by libjxl
    BUILD_COMMAND ${MAKE}
    INSTALL_COMMAND ${MAKE} install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(ffmpeg)
cleanup(ffmpeg install)
