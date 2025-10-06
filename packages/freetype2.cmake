ExternalProject_Add(freetype2
    GIT_REPOSITORY https://github.com/freetype/freetype.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    GIT_SUBMODULES ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 meson setup <BINARY_DIR> <SOURCE_DIR>
        --cross-file=${MESON_CROSS}
        -Dharfbuzz=disabled
        -Dtests=disabled
        -Dpng=disabled
        -Dbrotli=disabled
        -Dzlib=disabled
    BUILD_COMMAND ${EXEC} ninja
    INSTALL_COMMAND ${EXEC} ninja install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(freetype2)
force_meson_configure(freetype2)
cleanup(freetype2 install)
