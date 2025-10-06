ExternalProject_Add(lcms2
    GIT_REPOSITORY https://github.com/mm2/Little-CMS.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>
        --cross-file=${MESON_CROSS}
        -Dtests=disabled
        -Djpeg=disabled
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(lcms2)
force_meson_configure(lcms2)
cleanup(lcms2 install)
