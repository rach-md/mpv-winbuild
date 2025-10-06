ExternalProject_Add(dav1d
    GIT_REPOSITORY https://github.com/videolan/dav1d.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>
        --cross-file=${MESON_CROSS}
        -Denable_tools=false
        -Denable_tests=false
        -Dxxhash_muxer=disabled
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(dav1d)
force_meson_configure(dav1d)
cleanup(dav1d install)
