ExternalProject_Add(zstd
    GIT_REPOSITORY https://github.com/facebook/zstd.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    GIT_REMOTE_NAME origin
    GIT_TAG dev
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>/build/meson
        --prefix=${MINGW_INSTALL_PREFIX}
        --libdir=${MINGW_INSTALL_PREFIX}/lib
        --cross-file=${MESON_CROSS}
        --buildtype=release
        --default-library=static
        -Dlegacy_level=0
        -Ddebug_level=0
        -Dbin_programs=false
        -Dbin_tests=false
        -Dbin_contrib=false
        -Dmulti_thread=enabled
        -Dzlib=disabled
        -Dlzma=disabled
        -Dlz4=disabled
    BUILD_COMMAND ${EXEC} meson compile -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} meson install -C <BINARY_DIR>
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(zstd)
force_meson_configure(zstd)
cleanup(zstd install)
